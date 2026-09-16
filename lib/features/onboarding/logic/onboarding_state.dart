part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

final class OnboardingSuccess extends OnboardingState {
  final List<SplashItemModel> splashes;
  const OnboardingSuccess(this.splashes);

  @override
  List<Object?> get props => [splashes];
}

final class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
