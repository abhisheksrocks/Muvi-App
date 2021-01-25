// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'carousel_page_controller_state.dart';

class CarouselPageControllerCubit extends Cubit<CarouselPageControllerState> {
  CarouselPageControllerCubit()
      : super(CarouselPageControllerState(
            currentPage: 150, viewportFraction: 1 / 2));

  void setPage(double pageNumber) {
    emit(CarouselPageControllerState(
        currentPage: pageNumber, viewportFraction: state.viewportFraction));
  }

  void setViewportFraction(double newViewport) {
    emit(CarouselPageControllerState(
        currentPage: state.currentPage, viewportFraction: newViewport));
  }
}
