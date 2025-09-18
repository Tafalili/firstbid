import 'package:bidmarket/presentation/screens/home/product_cubit/product_state.dart';
import 'package:bidmarket/presentation/screens/home/product_cubit/products.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchProducts({String? categoryId}) async {
    try {
      emit(ProductLoading());

      print('🔄 جاري جلب المنتجات...');
      if (categoryId != null) {
        print('📂 تصفية حسب التصنيف: $categoryId');
      }

      var queryBuilder = supabase.from('products').select();

      if (categoryId != null) {
        queryBuilder = queryBuilder.eq('category_id', categoryId);
      }

      final data = await queryBuilder.order('end_date', ascending: true);

      print('📦 تم استلام ${data.length} منتج');

      final List<Products> products = data
          .map((item) => Products.fromJson(item))
          .toList();

      print('✅ تم تحويل المنتجات بنجاح');
      emit(ProductSuccess(products));

    } on PostgrestException catch (e) {
      print('❌ خطأ Supabase: ${e.message}');
      emit(ProductError('خطأ في قاعدة البيانات: ${e.message}'));
    } catch (e) {
      print('❌ خطأ عام: $e');
      emit(ProductError('خطأ غير متوقع: ${e.toString()}'));
    }
  }
}
