# Clean Architecture Fix Examples

This document provides concrete code examples to fix the violations found in the audit.

---

## Pattern 1: Fixing Direct Datasource Access

### ❌ WRONG (Current Implementation)

**File**: `lib/features/product/presentation/pages/latest_colors_page.dart`

```dart
@override
Widget build(BuildContext context) {
  // 🔴 VIOLATION: Direct datasource access in presentation
  final dataSource = ref.watch(colorCatalogueDataSourceProvider);

  return Scaffold(
    body: StreamBuilder<DatabaseEvent>(
      stream: dataSource.colorCategoriesStream(),
      builder: (context, snapshot) {
        // ...
      },
    ),
  );
}
```

### ✅ CORRECT (Fixed Implementation)

**Step 1**: Create repository (if not exists)

```dart
// lib/features/product/domain/repositories/color_catalogue_repository.dart
import '../entities/color_entity.dart';

abstract class ColorCatalogueRepository {
  Stream<List<ColorEntity>> getColorCategories();
  Future<ColorEntity?> getColorDetails(String colorId);
}
```

**Step 2**: Create usecase

```dart
// lib/features/product/domain/usecases/get_color_categories.dart
import '../repositories/color_catalogue_repository.dart';
import '../entities/color_entity.dart';

class GetColorCategories {
  final ColorCatalogueRepository repository;

  GetColorCategories(this.repository);

  Stream<List<ColorEntity>> call() {
    return repository.getColorCategories();
  }
}
```

**Step 3**: Update providers

```dart
// lib/features/product/presentation/providers/product_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Hide datasource - don't expose to presentation!
final _colorCatalogueDataSourceProvider = Provider<ColorCatalogueDataSource>((ref) {
  return ColorCatalogueDataSource();
});

// Expose repository
final colorCatalogueRepositoryProvider = Provider<ColorCatalogueRepository>((ref) {
  final dataSource = ref.read(_colorCatalogueDataSourceProvider);
  return ColorCatalogueRepositoryImpl(dataSource);
});

// Expose usecase
final getColorCategoriesUseCaseProvider = Provider<GetColorCategories>((ref) {
  return GetColorCategories(ref.read(colorCatalogueRepositoryProvider));
});

// Expose stream for UI consumption
final colorCategoriesStreamProvider = StreamProvider<List<ColorEntity>>((ref) {
  return ref.read(getColorCategoriesUseCaseProvider).call();
});
```

**Step 4**: Use in presentation (correct way)

```dart
// lib/features/product/presentation/pages/latest_colors_page.dart
@override
Widget build(BuildContext context) {
  // ✅ CORRECT: Access through usecase/stream provider
  final colorStream = ref.watch(colorCategoriesStreamProvider);

  return Scaffold(
    body: colorStream.when(
      data: (colors) => ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          // Build UI
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    ),
  );
}
```

---

## Pattern 2: Fixing Business Logic in Presentation

### ❌ WRONG (Current Implementation)

**File**: `lib/features/admin/presentation/pages/add_product_page.dart`

```dart
Future<void> _updateProduct() async {
  // 🔴 VIOLATION: Business logic in presentation layer
  String mainImageUrl = _mainImageFile != null 
    ? await CloudinaryUploadService.uploadImage(_mainImageFile!, 'product_images')
    : _product.mainImageUrl;
  
  String brochureUrl = _brochureFile != null 
    ? await CloudinaryUploadService.uploadRaw(_brochureFile!, 'brochures')
    : _product.brochureUrl;

  final updatedProductData = { /* ... */ };
  await ref.read(productRemoteDataSourceProvider).updateProduct(
    key, updatedProductData
  );
}
```

### ✅ CORRECT (Fixed Implementation)

**Step 1**: Create domain entities and usecase

```dart
// lib/features/product/domain/entities/upload_file_entity.dart
class UploadedFile {
  final String url;
  final String fileName;
  final DateTime uploadedAt;

  UploadedFile({
    required this.url,
    required this.fileName,
    required this.uploadedAt,
  });
}

// lib/features/product/domain/usecases/upload_product_file.dart
import 'dart:io';
import '../entities/upload_file_entity.dart';
import '../repositories/file_upload_repository.dart';

class UploadProductFile {
  final FileUploadRepository repository;

  UploadProductFile(this.repository);

  Future<UploadedFile> call({
    required File file,
    required String folder,
  }) async {
    return repository.uploadFile(file: file, folder: folder);
  }
}

// lib/features/product/domain/usecases/update_product_with_files.dart
import 'dart:io';
import '../repositories/product_repository.dart';

class UpdateProductWithFiles {
  final ProductRepository repository;
  final FileUploadRepository fileRepository;

  UpdateProductWithFiles(this.repository, this.fileRepository);

  Future<void> call({
    required String productKey,
    required Map<String, dynamic> productData,
    Map<String, File>? filesToUpload,
  }) async {
    // Upload files if provided
    if (filesToUpload != null) {
      for (final entry in filesToUpload.entries) {
        final uploadedFile = await fileRepository.uploadFile(
          file: entry.value,
          folder: entry.key,
        );
        productData[entry.key] = uploadedFile.url;
      }
    }

    // Update product
    await repository.updateProduct(productKey, productData);
  }
}
```

**Step 2**: Create repository abstraction

```dart
// lib/features/product/domain/repositories/file_upload_repository.dart
import 'dart:io';
import '../entities/upload_file_entity.dart';

abstract class FileUploadRepository {
  Future<UploadedFile> uploadFile({
    required File file,
    required String folder,
  });
}
```

**Step 3**: Implement repository

```dart
// lib/features/product/data/repositories/file_upload_repository_impl.dart
import 'dart:io';
import '../../domain/entities/upload_file_entity.dart';
import '../../domain/repositories/file_upload_repository.dart';
import '../datasources/cloudinary_datasource.dart';

class FileUploadRepositoryImpl implements FileUploadRepository {
  final CloudinaryDataSource dataSource;

  FileUploadRepositoryImpl(this.dataSource);

  @override
  Future<UploadedFile> uploadFile({
    required File file,
    required String folder,
  }) async {
    final url = await dataSource.upload(file, folder);
    return UploadedFile(
      url: url,
      fileName: file.path.split('/').last,
      uploadedAt: DateTime.now(),
    );
  }
}

// lib/features/product/data/datasources/cloudinary_datasource.dart
import 'dart:io';
import '../../../core/services/cloudinary_upload_service.dart';

class CloudinaryDataSource {
  Future<String> upload(File file, String folder) async {
    final ext = file.path.toLowerCase();
    if (ext.endsWith('.pdf')) {
      return CloudinaryUploadService.uploadRaw(file, folder: folder);
    }
    return CloudinaryUploadService.uploadImage(file, folder: folder);
  }
}
```

**Step 4**: Provide usecases

```dart
// lib/features/product/presentation/providers/product_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _cloudinaryDataSourceProvider = Provider<CloudinaryDataSource>((ref) {
  return CloudinaryDataSource();
});

final fileUploadRepositoryProvider = Provider<FileUploadRepository>((ref) {
  return FileUploadRepositoryImpl(ref.read(_cloudinaryDataSourceProvider));
});

final uploadProductFileUseCaseProvider = Provider<UploadProductFile>((ref) {
  return UploadProductFile(ref.read(fileUploadRepositoryProvider));
});

final updateProductWithFilesUseCaseProvider = Provider<UpdateProductWithFiles>((ref) {
  return UpdateProductWithFiles(
    ref.read(productRepositoryProvider),
    ref.read(fileUploadRepositoryProvider),
  );
});
```

**Step 5**: Create notifier

```dart
// lib/features/product/presentation/providers/product_notifier.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/update_product_with_files.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final UpdateProductWithFiles updateProductWithFiles;

  ProductNotifier({required this.updateProductWithFiles})
      : super(ProductState());

  Future<bool> updateProduct({
    required String productKey,
    required Map<String, dynamic> productData,
    Map<String, File>? filesToUpload,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await updateProductWithFiles(
        productKey: productKey,
        productData: productData,
        filesToUpload: filesToUpload,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final productNotifierProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier(
    updateProductWithFiles: ref.read(updateProductWithFilesUseCaseProvider),
  );
});
```

**Step 6**: Use in presentation (correct way)

```dart
// lib/features/product/presentation/pages/edit_product_page.dart
Future<void> _updateProduct() async {
  // ✅ CORRECT: All business logic through notifier
  final success = await ref.read(productNotifierProvider.notifier).updateProduct(
    productKey: widget.productKey,
    productData: {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'stock': int.tryParse(_stockController.text.trim()) ?? 0,
    },
    filesToUpload: {
      'mainImageUrl': _mainImageFile,
      'backgroundImageUrl': _backgroundImageFile,
      'brochureUrl': _brochureFile,
    }.whereType<String, File>().map((k, v) => MapEntry(k, v!)).cast<String, File>(),
  );

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product updated successfully')),
    );
  }
}
```

---

## Pattern 3: Fixing Inconsistent Provider Patterns

### ❌ WRONG (Inconsistent)

```dart
// Feature A - Uses StateNotifierProvider
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(...);
});

// Feature B - Uses AsyncNotifierProvider
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});

// Feature C - Uses StreamProvider directly (no notifier)
final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRemoteDataSourceProvider).productsStream()...
});
```

### ✅ CORRECT (Standardized)

All state management should use **StateNotifierProvider** for consistency:

```dart
// ✅ Standard Pattern
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(
    getCartStream: ref.read(getCartStreamUseCaseProvider),
    updateQuantity: ref.read(updateQuantityUseCaseProvider),
  );
});

// ✅ For async operations
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    googleSignInUseCase: ref.read(googleSignInUseCaseProvider),
  );
});

// AuthState should handle loading/success/error
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final User? user;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
      user: user ?? this.user,
    );
  }
}

// ✅ For read-only data (NO mutations)
final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  final useCase = ref.read(getProductsUseCaseProvider);
  return useCase();
});
```

---

## Pattern 4: Complete Domain Layer Structure

### ❌ WRONG (Incomplete - Auth Feature)

```
auth/
├── data/
│   ├── datasources/
│   └── repositories/
├── domain/
│   └── repositories/          ❌ Empty except abstract repo
└── presentation/
```

### ✅ CORRECT (Complete)

```
auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── auth_state_entity.dart
│   │   └── user_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       ├── google_sign_in_usecase.dart
│       ├── reset_password_usecase.dart
│       ├── logout_usecase.dart
│       └── get_current_user_usecase.dart
└── presentation/
    ├── pages/
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   └── forgot_password_page.dart
    └── providers/
        ├── auth_providers.dart
        ├── auth_notifier.dart
        └── auth_state.dart
```

Example implementations:

```dart
// lib/features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImageUrl;
  final String userRole;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImageUrl,
    required this.userRole,
    required this.createdAt,
  });
}

// lib/features/auth/domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return repository.signInWithEmailAndPassword(email, password);
  }
}

// lib/features/auth/presentation/providers/auth_providers.dart
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    googleSignInUseCase: ref.read(googleSignInUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
  );
});
```

---

## Summary of Fixes

| Issue | Solution |
|-------|----------|
| Direct datasource access | Create repositories + usecases + stream providers |
| Business logic in UI | Move to usecases, access via notifiers |
| Inconsistent patterns | Use StateNotifierProvider everywhere |
| Incomplete domain | Add entities, usecases for all operations |
| Missing abstractions | Create repositories for all data sources |

Apply these patterns systematically across all features to achieve 100% Clean Architecture + Riverpod compliance.
