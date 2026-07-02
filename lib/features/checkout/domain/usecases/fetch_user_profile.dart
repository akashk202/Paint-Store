import '../entities/checkout_profile.dart';
import '../repositories/checkout_repository.dart';

class FetchUserProfile {
  final CheckoutRepository repository;

  FetchUserProfile(this.repository);

  Future<CheckoutProfile?> call() {
    return repository.fetchUserProfile();
  }
}

// implements UseCase
