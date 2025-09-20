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
      print('🔄 جاري جلب الفئات...');
      emit(CategoryLoading());

      final locale = context.locale;
      final languageCode = locale.languageCode.toLowerCase();

      print('🌍 اللغة المكتشفة: $languageCode');
      print('🌍 Locale كامل: $locale');
      print('🌍 toString: ${locale.toString()}');

      // استخدام الطريقة الآمنة - جلب كلا العمودين
      final List<Map<String, dynamic>> rawData = await supabase
          .from('categories')
          .select('id, name_en, name_ar, icon_url');

      print('✅ تم جلب البيانات الخام بنجاح');

      // معالجة البيانات حسب اللغة
      final List<Map<String, dynamic>> data = rawData.map((item) {
        String name;

        // تحديد الاسم حسب اللغة
        if (languageCode.contains('ar') || locale.toString().contains('ar')) {
          name = item['name_ar'] ?? item['name_en'] ?? 'بدون اسم';
          print('🌍 استخدام العربية: $name');
        } else {
          name = item['name_en'] ?? item['name_ar'] ?? 'No name';
          print('🌍 استخدام الإنجليزية: $name');
        }

        return {
          'id': item['id'],
          'name': name,
          'icon_url': item['icon_url'],
        };
      }).toList();

      print('✅ تم معالجة الفئات بنجاح. العدد: ${data.length}');
      print('📦 البيانات المعالجة: $data');

      if (data.isNotEmpty) {
        emit(CategorySuccess(data));
      } else {
        print('⚠️ لم يتم العثور على فئات.');
        emit(CategoryError('لم يتم العثور على فئات.'));
      }
    } on PostgrestException catch (e) {
      print('❌ خطأ Supabase: ${e.message}');
      print('❌ تفاصيل الخطأ: ${e.details}');
      print('❌ كود الخطأ: ${e.code}');
      emit(CategoryError('خطأ في قاعدة البيانات: ${e.message}'));
    } catch (e) {
      print('❌ خطأ عام: $e');
      print('❌ نوع الخطأ: ${e.runtimeType}');
      emit(CategoryError('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  // طريقة بديلة - جلب كلا العمودين والاختيار في العميل
  Future<void> fetchCategoriesAlternative(BuildContext context) async {
    try {
      print('🔄 جاري جلب الفئات (الطريقة البديلة)...');
      emit(CategoryLoading());

      final String languageCode = context.locale.languageCode;
      print('🌍 كود اللغة: $languageCode');

      // جلب كلا عمودي اللغة
      final List<Map<String, dynamic>> rawData = await supabase
          .from('categories')
          .select('id, name_en, name_ar, icon_url');

      // معالجة البيانات في العميل
      final List<Map<String, dynamic>> processedData = rawData.map((item) {
        String name;
        if (languageCode.startsWith('ar')) {
          name = item['name_ar'] ?? item['name_en'] ?? 'بدون اسم';
        } else {
          name = item['name_en'] ?? item['name_ar'] ?? 'No name';
        }

        return {
          'id': item['id'],
          'name': name,
          'icon_url': item['icon_url'],
        };
      }).toList();

      print('✅ تم معالجة الفئات بنجاح. العدد: ${processedData.length}');
      print('📦 البيانات المعالجة: $processedData');

      if (processedData.isNotEmpty) {
        emit(CategorySuccess(processedData));
      } else {
        print('⚠️ لم يتم العثور على فئات.');
        emit(CategoryError('لم يتم العثور على فئات.'));
      }
    } on PostgrestException catch (e) {
      print('❌ خطأ Supabase: ${e.message}');
      emit(CategoryError('خطأ في قاعدة البيانات: ${e.message}'));
    } catch (e) {
      print('❌ خطأ عام: $e');
      emit(CategoryError('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }
}