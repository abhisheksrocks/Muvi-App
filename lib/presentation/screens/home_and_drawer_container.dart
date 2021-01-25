// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/animated_drawer_cubit.dart';
import 'drawer_widget.dart';
import 'home_screen.dart';

class HomeAndDrawerContainer extends StatefulWidget {
  @override
  _HomeAndDrawerContainerState createState() => _HomeAndDrawerContainerState();
}

class _HomeAndDrawerContainerState extends State<HomeAndDrawerContainer>
    with SingleTickerProviderStateMixin {
  final Duration _animationDuration = Duration(milliseconds: 500);
  AnimationController _animationController;
  Animation<Offset> _slideTransition;
  Animation<double> _scaleAnimation;
  Animation<double> _borderRadius;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _borderRadius =
        Tween<double>(begin: 0, end: 40).animate(_animationController);

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.6,
    )
        .chain(CurveTween(curve: Curves.easeOutQuart))
        .animate(_animationController);

    _slideTransition = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0.6, 0),
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // print("This got called");
        if (context.read<AnimatedDrawerCubit>().state.isCollapsed) {
          return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: Text(
                'Are you sure?',
                style: Theme.of(context).textTheme.headline5,
              ),
              content: Text(
                'Do you want to exit the App?',
                style: Theme.of(context).textTheme.headline6,
              ),
              actions: <Widget>[
                OutlineButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                OutlineButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ));
        } else {
          context.read<AnimatedDrawerCubit>().changeCollapse();

          return false;
        }
      },
      child: BlocListener<AnimatedDrawerCubit, AnimatedDrawer>(
        listener: (context, state) {
          if (!state.isCollapsed) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: Stack(
            children: [
              DrawerWidget(
                animationController: _animationController,
              ),
              ScaleTransition(
                scale: _scaleAnimation,
                child: SlideTransition(
                  position: _slideTransition,
                  child: GestureDetector(
                    onHorizontalDragDown: (details) {
                      if (!context
                          .read<AnimatedDrawerCubit>()
                          .state
                          .isCollapsed) {
                        context.read<AnimatedDrawerCubit>().changeCollapse();
                      }
                    },
                    onTapDown: (details) {
                      if (!context
                          .read<AnimatedDrawerCubit>()
                          .state
                          .isCollapsed) {
                        context.read<AnimatedDrawerCubit>().changeCollapse();
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _borderRadius,
                      child: HomeScreen(),
                      builder: (context, child) => ClipRRect(
                        borderRadius: BorderRadius.circular(
                          _borderRadius.value,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
