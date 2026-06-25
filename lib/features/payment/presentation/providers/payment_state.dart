class PaymentState {
  final bool processing;
  final bool completed;
  final String? lastOrderId;
  final Object? error;

  const PaymentState({
    this.processing = false,
    this.completed = false,
    this.lastOrderId,
    this.error,
  });

  PaymentState copyWith({
    bool? processing,
    bool? completed,
    String? lastOrderId,
    Object? error,
  }) =>
      PaymentState(
        processing: processing ?? this.processing,
        completed: completed ?? this.completed,
        lastOrderId: lastOrderId ?? this.lastOrderId,
        error: error,
      );
}
