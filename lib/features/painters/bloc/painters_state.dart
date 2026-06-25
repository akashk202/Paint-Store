import 'package:equatable/equatable.dart';
import 'package:c_h_p/model/painter_model.dart';

/// States emitted by the PaintersBloc.
abstract class PaintersState extends Equatable {
  const PaintersState();

  @override
  List<Object?> get props => [];
}

/// Initial state before painters are loaded.
class PaintersInitial extends PaintersState {
  const PaintersInitial();
}

/// Painters data is being loaded.
class PaintersLoading extends PaintersState {
  const PaintersLoading();
}

/// Painters loaded successfully.
class PaintersLoaded extends PaintersState {
  final List<Painter> painters;

  const PaintersLoaded(this.painters);

  @override
  List<Object?> get props => [painters];
}

/// An error occurred while loading painters.
class PaintersError extends PaintersState {
  final String message;

  const PaintersError(this.message);

  @override
  List<Object?> get props => [message];
}
