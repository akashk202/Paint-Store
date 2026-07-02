import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class ObserveUnreadNotifications implements StreamUseCase<int, String> {
  final HomeRepository repository;

  ObserveUnreadNotifications(this.repository);

  @override
  Stream<int> call(String params) {
    return repository.unreadCountStream(params);
  }
}
