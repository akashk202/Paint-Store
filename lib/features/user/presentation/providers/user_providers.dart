import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:c_h_p/core/usecases/usecase.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/update_profile_picture.dart';
import '../../domain/usecases/delete_profile_picture.dart';
import '../../domain/usecases/update_user_password.dart';
import '../../domain/usecases/get_user_role.dart';
import '../../domain/usecases/fetch_pending_manager_requests.dart';
import '../../domain/usecases/approve_manager_request.dart';
import '../../domain/usecases/deny_manager_request.dart';
import '../../domain/usecases/fetch_all_users_stream.dart';
import '../../domain/usecases/update_user_role.dart';
import '../../domain/usecases/delete_user.dart';
import 'user_state.dart';
import 'user_notifier.dart';

final _userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl(
    auth: FirebaseAuth.instance,
    dbRef: FirebaseDatabase.instance.ref(),
    storage: FirebaseStorage.instance,
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(_userRemoteDataSourceProvider));
});

final getUserProfileUseCaseProvider = Provider<GetUserProfile>((ref) {
  return GetUserProfile(ref.read(userRepositoryProvider));
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfile>((ref) {
  return UpdateUserProfile(ref.read(userRepositoryProvider));
});

final updateProfilePictureUseCaseProvider = Provider<UpdateProfilePicture>((ref) {
  return UpdateProfilePicture(ref.read(userRepositoryProvider));
});

final deleteProfilePictureUseCaseProvider = Provider<DeleteProfilePicture>((ref) {
  return DeleteProfilePicture(ref.read(userRepositoryProvider));
});

final updateUserPasswordUseCaseProvider = Provider<UpdateUserPassword>((ref) {
  return UpdateUserPassword(ref.read(userRepositoryProvider));
});

final getUserRoleUseCaseProvider = Provider<GetUserRole>((ref) {
  return GetUserRole(ref.read(userRepositoryProvider));
});

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    getUserProfile: ref.read(getUserProfileUseCaseProvider),
    updateUserProfile: ref.read(updateUserProfileUseCaseProvider),
    updateProfilePicture: ref.read(updateProfilePictureUseCaseProvider),
    deleteProfilePicture: ref.read(deleteProfilePictureUseCaseProvider),
    updateUserPassword: ref.read(updateUserPasswordUseCaseProvider),
    getUserRole: ref.read(getUserRoleUseCaseProvider),
  );
});

final fetchPendingManagerRequestsUseCaseProvider = Provider<FetchPendingManagerRequests>((ref) {
  return FetchPendingManagerRequests(ref.read(userRepositoryProvider));
});

final approveManagerRequestUseCaseProvider = Provider<ApproveManagerRequest>((ref) {
  return ApproveManagerRequest(ref.read(userRepositoryProvider));
});

final denyManagerRequestUseCaseProvider = Provider<DenyManagerRequest>((ref) {
  return DenyManagerRequest(ref.read(userRepositoryProvider));
});

final fetchAllUsersStreamUseCaseProvider = Provider<FetchAllUsersStream>((ref) {
  return FetchAllUsersStream(ref.read(userRepositoryProvider));
});

final updateUserRoleUseCaseProvider = Provider<UpdateUserRole>((ref) {
  return UpdateUserRole(ref.read(userRepositoryProvider));
});

final deleteUserUseCaseProvider = Provider<DeleteUser>((ref) {
  return DeleteUser(ref.read(userRepositoryProvider));
});

final allUsersStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(fetchAllUsersStreamUseCaseProvider).call(const NoParams());
});
