import os

workspace_dir = r"c:\Users\AK\Documents\Paint-Store"
usecases_dir = os.path.join(workspace_dir, "lib", "features", "cart", "domain", "usecases")

# 1. add_or_update_item.dart
with open(os.path.join(usecases_dir, "add_or_update_item.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class AddOrUpdateItem implements UseCase<void, AddOrUpdateItemParams> {
  final CartRepository repository;

  AddOrUpdateItem(this.repository);

  @override
  Future<Either<Failure, void>> call(AddOrUpdateItemParams params) {
    return repository.addOrUpdateItem(
      productKey: params.productKey,
      name: params.name,
      imageUrl: params.imageUrl,
      size: params.size,
      price: params.price,
    );
  }
}

class AddOrUpdateItemParams extends Equatable {
  final String productKey;
  final String name;
  final String imageUrl;
  final String size;
  final String price;

  const AddOrUpdateItemParams({
    required this.productKey,
    required this.name,
    required this.imageUrl,
    required this.size,
    required this.price,
  });

  @override
  List<Object?> get props => [productKey, name, imageUrl, size, price];
}
''')

# 2. change_size.dart
with open(os.path.join(usecases_dir, "change_size.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class ChangeSize implements UseCase<void, ChangeSizeParams> {
  final CartRepository repository;

  ChangeSize(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeSizeParams params) {
    return repository.changeSize(
      productKey: params.productKey,
      size: params.size,
      price: params.price,
    );
  }
}

class ChangeSizeParams extends Equatable {
  final String productKey;
  final String size;
  final String price;

  const ChangeSizeParams({
    required this.productKey,
    required this.size,
    required this.price,
  });

  @override
  List<Object?> get props => [productKey, size, price];
}
''')

# 3. clear_cart.dart
with open(os.path.join(usecases_dir, "clear_cart.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class ClearCart implements UseCase<void, NoParams> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearCart();
  }
}
''')

# 4. fetch_product_details.dart
with open(os.path.join(usecases_dir, "fetch_product_details.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class FetchProductDetails implements UseCase<Map<String, Map<String, dynamic>?>, List<String>> {
  final CartRepository repository;

  FetchProductDetails(this.repository);

  @override
  Future<Either<Failure, Map<String, Map<String, dynamic>?>>> call(List<String> params) {
    return repository.fetchProductDetails(params);
  }
}
''')

# 5. get_cart_stream.dart
with open(os.path.join(usecases_dir, "get_cart_stream.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCartStream implements StreamUseCase<List<CartItem>, NoParams> {
  final CartRepository repository;

  GetCartStream(this.repository);

  @override
  Stream<List<CartItem>> call(NoParams params) {
    return repository.cartStream();
  }
}
''')

# 6. remove_item.dart
with open(os.path.join(usecases_dir, "remove_item.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveItem implements UseCase<void, String> {
  final CartRepository repository;

  RemoveItem(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.removeItem(params);
  }
}
''')

# 7. update_quantity.dart
with open(os.path.join(usecases_dir, "update_quantity.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class UpdateQuantity implements UseCase<void, UpdateQuantityParams> {
  final CartRepository repository;

  UpdateQuantity(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateQuantityParams params) {
    return repository.updateQuantity(
      productKey: params.productKey,
      quantity: params.quantity,
    );
  }
}

class UpdateQuantityParams extends Equatable {
  final String productKey;
  final int quantity;

  const UpdateQuantityParams({required this.productKey, required this.quantity});

  @override
  List<Object?> get props => [productKey, quantity];
}
''')

print("All cart usecases refactored successfully!")
