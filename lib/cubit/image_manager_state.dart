part of 'image_manager_cubit.dart';

@immutable
abstract class ImageManagerState {}

class ImageManagerLoading extends ImageManagerState {}

class ImageManagerLoaded extends ImageManagerState {}

class ImageManagerFailed extends ImageManagerState {
  final bool isImagepathEmpty;
  ImageManagerFailed({
    this.isImagepathEmpty = false,
  });
}
