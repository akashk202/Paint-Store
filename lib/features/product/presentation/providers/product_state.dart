class ProductState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ProductState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
