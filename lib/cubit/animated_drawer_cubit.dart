// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'animated_drawer_state.dart';

class AnimatedDrawerCubit extends Cubit<AnimatedDrawer> {
  AnimatedDrawerCubit()
      : super(AnimatedDrawer(
          isCollapsed: false,
        ));

  void changeCollapse() {
    emit(AnimatedDrawer(isCollapsed: !state.isCollapsed));
  }

  void animationControllerUpdated() {
    emit(AnimatedDrawer(isCollapsed: state.isCollapsed));
  }
}
