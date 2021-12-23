part of 'carousel_page_controller_cubit.dart';

@immutable
class CarouselPageControllerState {
  final double currentPage;
  final double viewportFraction;
  CarouselPageControllerState({
    required this.currentPage,
    required this.viewportFraction,
  });
}
