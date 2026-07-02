import os

workspace_dir = r"c:\Users\AK\Documents\Paint-Store"
usecases_dir = os.path.join(workspace_dir, "lib", "features", "product", "domain", "usecases")

# 1. add_product.dart
with open(os.path.join(usecases_dir, "add_product.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class AddProduct implements UseCase<void, Map<String, dynamic>> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(Map<String, dynamic> params) {
    return repository.addProduct(params);
  }
}
''')

# 2. delete_product.dart
with open(os.path.join(usecases_dir, "delete_product.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProduct implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteProduct(params);
  }
}
''')

# 3. fetch_all_products.dart
with open(os.path.join(usecases_dir, "fetch_all_products.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class FetchAllProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  FetchAllProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return repository.fetchAll();
  }
}
''')

# 4. get_products_stream.dart
with open(os.path.join(usecases_dir, "get_products_stream.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsStream implements StreamUseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProductsStream(this.repository);

  @override
  Stream<List<Product>> call(NoParams params) {
    return repository.productsStream();
  }
}
''')

# 5. update_product.dart
with open(os.path.join(usecases_dir, "update_product.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class UpdateProduct implements UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) {
    return repository.updateProduct(params.key, params.data);
  }
}

class UpdateProductParams extends Equatable {
  final String key;
  final Map<String, dynamic> data;

  const UpdateProductParams({required this.key, required this.data});

  @override
  List<Object?> get props => [key, data];
}
''')

# 6. upload_image_file.dart
with open(os.path.join(usecases_dir, "upload_image_file.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/upload_repository.dart';

class UploadImageFile implements UseCase<String, UploadFileParams> {
  final UploadRepository repository;

  UploadImageFile(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadFileParams params) {
    return repository.uploadImage(params.file, folder: params.folder);
  }
}

class UploadFileParams extends Equatable {
  final File file;
  final String folder;

  const UploadFileParams({required this.file, required this.folder});

  @override
  List<Object?> get props => [file, folder];
}
''')

# 7. upload_raw_file.dart
with open(os.path.join(usecases_dir, "upload_raw_file.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/upload_repository.dart';
import 'upload_image_file.dart'; // To reuse UploadFileParams

class UploadRawFile implements UseCase<String, UploadFileParams> {
  final UploadRepository repository;

  UploadRawFile(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadFileParams params) {
    return repository.uploadRaw(params.file, folder: params.folder);
  }
}
''')

print("All product usecases refactored successfully!")
