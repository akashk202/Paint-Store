import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/features/checkout/domain/repositories/checkout_repository.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

export 'checkout_event.dart';
export 'checkout_state.dart';

/// CheckoutBloc: manages checkout form state.
/// Loads user profile and cart items via [CheckoutRepository].
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository checkoutRepository;

  CheckoutBloc({required this.checkoutRepository})
      : super(const CheckoutInitial()) {
    on<LoadUserProfile>(_onLoadProfile);
    on<UpdateUserProfile>(_onUpdateProfile);
    on<FetchCartItemNames>(_onFetchCartItems);
  }

  Future<void> _onLoadProfile(
    LoadUserProfile event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());
    try {
      final profile = await checkoutRepository.fetchUserProfile();
      emit(CheckoutProfileLoaded(profile: profile));
    } catch (e) {
      emit(CheckoutError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateUserProfile event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      await checkoutRepository.updateUserProfile(
        fullName: event.fullName,
        phone: event.phone,
        email: event.email,
        address: event.address,
        lat: event.lat,
        lng: event.lng,
      );
      emit(const CheckoutProfileUpdated());
    } catch (e) {
      emit(CheckoutError('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onFetchCartItems(
    FetchCartItemNames event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      final names = await checkoutRepository.fetchCartItemNames();
      final current = state;
      if (current is CheckoutProfileLoaded) {
        emit(current.copyWith(cartItemNames: names));
      } else {
        emit(CheckoutProfileLoaded(cartItemNames: names));
      }
    } catch (e) {
      emit(CheckoutError('Failed to fetch cart items: ${e.toString()}'));
    }
  }
}
