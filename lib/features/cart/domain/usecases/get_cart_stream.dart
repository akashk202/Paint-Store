import 'package:c_h_p/core/usecases/usecase.dart';
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
