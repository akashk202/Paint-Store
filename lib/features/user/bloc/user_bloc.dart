import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

export 'user_event.dart';
export 'user_state.dart';

/// UserBloc: manages user role state.
/// Supports one-off fetch, real-time stream, and admin role assignment.
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;
  StreamSubscription<String>? _roleSub;

  UserBloc({required this.repository}) : super(const UserInitial()) {
    on<FetchUserRole>(_onFetchRole);
    on<SubscribeToUserRole>(_onSubscribeRole);
    on<UserRoleUpdated>(_onRoleUpdated);
    on<SetUserRole>(_onSetRole);
  }

  Future<void> _onFetchRole(
    FetchUserRole event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    try {
      final role = await repository.fetchUserRole(event.uid);
      emit(UserRoleLoaded(role));
    } catch (e) {
      emit(UserError('Failed to fetch user role: ${e.toString()}'));
    }
  }

  Future<void> _onSubscribeRole(
    SubscribeToUserRole event,
    Emitter<UserState> emit,
  ) async {
    await _roleSub?.cancel();
    _roleSub = repository.userRoleStream(event.uid).listen(
      (role) => add(UserRoleUpdated(role)),
      onError: (error) => add(const UserRoleUpdated('Customer')),
    );
  }

  void _onRoleUpdated(
    UserRoleUpdated event,
    Emitter<UserState> emit,
  ) {
    emit(UserRoleLoaded(event.role));
  }

  Future<void> _onSetRole(
    SetUserRole event,
    Emitter<UserState> emit,
  ) async {
    try {
      await repository.setUserRole(uid: event.uid, role: event.role);
      emit(const UserRoleSetSuccess());
    } catch (e) {
      emit(UserError('Failed to set user role: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _roleSub?.cancel();
    return super.close();
  }
}
