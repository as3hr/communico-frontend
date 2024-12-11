class HomeState {
  bool isLoading;

  HomeState({
    this.isLoading = true,
  });

  factory HomeState.empty() => HomeState();

  copyWith({
    bool? isLoading,
  }) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
      );
}
