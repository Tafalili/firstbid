part of 'carousel_cubit.dart';

@immutable
abstract class CarouselState {}

class CarouselInitial extends CarouselState {}

class CarouselLoading extends CarouselState {}

class CarouselSuccess extends CarouselState {
final List<String> banners;

CarouselSuccess(this.banners);
}

class CarouselError extends CarouselState {
final String message;

CarouselError(this.message);
}
