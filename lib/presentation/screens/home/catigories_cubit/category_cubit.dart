import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';



part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchCategories(BuildContext context) async {
    try {
      emit(CategoryLoading());
      final String languageCode = context.locale.languageCode;
      final String nameColumn = 'name_$languageCode';
      final List<Map<String, dynamic>> data = await supabase
          .from('categories')
          .select('id, $nameColumn as name, icon_url');

      emit(CategorySuccess(data));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

// The rest of the cubit code...
}
