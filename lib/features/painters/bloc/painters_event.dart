import 'package:equatable/equatable.dart';
import 'package:c_h_p/model/painter_model.dart';

/// Events dispatched by the Painters UI to the PaintersBloc.
abstract class PaintersEvent extends Equatable {
  const PaintersEvent();

  @override
  List<Object?> get props => [];
}

/// Subscribe to the real-time painters stream.
class SubscribeToPainters extends PaintersEvent {
  const SubscribeToPainters();
}

/// Painters data updated from the Firebase stream.
class PaintersDataUpdated extends PaintersEvent {
  final List<Painter> painters;

  const PaintersDataUpdated(this.painters);

  @override
  List<Object?> get props => [painters];
}
