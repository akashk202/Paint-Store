import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/upload_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/upload_repository.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/fetch_all_products.dart';
import '../../domain/usecases/get_products_stream.dart';
import '../../domain/usecases/upload_raw_file.dart';
import '../../domain/usecases/upload_image_file.dart';

final _productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource();
});

final _productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(_productRemoteDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
});

final _uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepositoryImpl();
});

final addProductUseCaseProvider = Provider<AddProduct>((ref) {
  return AddProduct(ref.watch(_productRepositoryProvider));
});

final updateProductUseCaseProvider = Provider<UpdateProduct>((ref) {
  return UpdateProduct(ref.watch(_productRepositoryProvider));
});

final deleteProductUseCaseProvider = Provider<DeleteProduct>((ref) {
  return DeleteProduct(ref.watch(_productRepositoryProvider));
});

final fetchAllProductsUseCaseProvider = Provider<FetchAllProducts>((ref) {
  return FetchAllProducts(ref.watch(_productRepositoryProvider));
});

final getProductsStreamUseCaseProvider = Provider<GetProductsStream>((ref) {
  return GetProductsStream(ref.watch(_productRepositoryProvider));
});

final uploadRawFileUseCaseProvider = Provider<UploadRawFile>((ref) {
  return UploadRawFile(ref.watch(_uploadRepositoryProvider));
});

final uploadImageFileUseCaseProvider = Provider<UploadImageFile>((ref) {
  return UploadImageFile(ref.watch(_uploadRepositoryProvider));
});

final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  final getProductsStream = ref.watch(getProductsStreamUseCaseProvider);
  return getProductsStream();
});
