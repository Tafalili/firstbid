import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../product_cubit/products.dart';
import 'bids.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  final SupabaseClient supabase = Supabase.instance.client;
  late final RealtimeChannel _bidsChannel;

  Future<void> fetchProductDetails(String productId) async {
    try {
      emit(ProductDetailsLoading());

      // Fetch product details
      final productData = await supabase
          .from('products')
          .select('*, description_ar, description_en')
          .eq('id', productId)
          .single();

      final product = Products.fromJson(productData);

      // Fetch bidders for the product
      final bidsData = await supabase
          .from('bids')
          .select('*, profiles(full_name)')
          .eq('product_id', productId)
          .order('bid_amount', ascending: false);

      final List<Bids> bids = bidsData.map((bid) => Bids.fromJson(bid)).toList();

      _setupBidsRealtimeSubscription(productId);

      emit(ProductDetailsSuccess(product: product, bids: bids));

    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  void _setupBidsRealtimeSubscription(String productId) {
    _bidsChannel = supabase.channel('public:bids')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'bids',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'product_id',
        value: productId,
      ),
      callback: (payload) async {
        // Fetch the updated bids list
        final newBidsData = await supabase
            .from('bids')
            .select('*, profiles(full_name)')
            .eq('product_id', productId)
            .order('bid_amount', ascending: false);

        final List<Bids> newBids = newBidsData.map((bid) => Bids.fromJson(bid)).toList();

        // Update the current state
        if (state is ProductDetailsSuccess) {
          final currentProduct = (state as ProductDetailsSuccess).product;
          emit(ProductDetailsSuccess(product: currentProduct, bids: newBids));
        }
      },
    )
        .subscribe();
  }

  void disposeRealtimeSubscription() {
    supabase.removeChannel(_bidsChannel);
  }

  Future<void> placeBid(String productId, num bidAmount) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw 'User not authenticated.';
      }

      // Update the product's current price
      await supabase
          .from('products')
          .update({'current_price': bidAmount})
          .eq('id', productId);

      // Insert the new bid into the bids table
      await supabase.from('bids').insert({
        'product_id': productId,
        'user_id': userId,
        'bid_amount': bidAmount,
      });

    } on PostgrestException catch (e) {
      emit(ProductDetailsError(e.message));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }
}