import '../../domain/repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';

class GetCartStream {
  final CartRepository repository;

  GetCartStream(this.repository);

  Stream<List<CartItem>> call() {
    return repository.cartStream();
  }
}