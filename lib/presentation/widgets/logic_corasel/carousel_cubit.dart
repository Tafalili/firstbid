import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'carousel_state.dart';

class CarouselCubit extends Cubit<CarouselState> {
  CarouselCubit() : super(CarouselInitial());

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchBanners() async {
    try {
      emit(CarouselLoading());
      final List<Map<String, dynamic>> data = await supabase
          .from('carousel_images')
          .select('image_url')
          .order('order', ascending: true);

      final List<String> banners = data.map((item) => item['image_url'] as String).toList();
      emit(CarouselSuccess(banners));
    } catch (e) {
      emit(CarouselError(e.toString()));
    }
  }
}