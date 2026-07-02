import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class FetchAllUsersStream implements StreamUseCase<Map<String, dynamic>, NoParams> {
  final UserRepository repository;

  FetchAllUsersStream(this.repository);

  @override
  Stream<Map<String, dynamic>> call(NoParams params) {
    return repository.fetchAllUsersStream();
  }
}
