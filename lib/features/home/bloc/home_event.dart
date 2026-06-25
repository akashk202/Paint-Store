import 'package:equatable/equatable.dart';

/// Events dispatched by the Home UI to the HomeBloc.
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load featured products for the home page.
class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

/// Subscribe to unread notification count.
class SubscribeToUnreadCount extends HomeEvent {
  final String uid;

  const SubscribeToUnreadCount(this.uid);

  @override
  List<Object?> get props => [uid];
}

/// Unread count updated from Firebase stream.
class UnreadCountUpdated extends HomeEvent {
  final int count;

  const UnreadCountUpdated(this.count);

  @override
  List<Object?> get props => [count];
}
