import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import '../screens/home/product_cubit/product_cubit.dart';
import '../screens/home/product_cubit/product_state.dart';
import '../screens/home/product_cubit/products.dart';
import '../screens/home/product_detiles/product_detiles_screen.dart';
import 'all_products_screen.dart';

// Your Products Grid View
class HomeProductsGrid extends StatefulWidget {
  const HomeProductsGrid({super.key});

  @override
  _HomeProductsGridState createState() => _HomeProductsGridState();
}

class _HomeProductsGridState extends State<HomeProductsGrid> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // استدعاء جلب البيانات هنا يحل مشكلة الـ context
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductSuccess) {
          final now = DateTime.now();

          // Separate ongoing and ended auctions
          final ongoingAuctions = state.products
              .where((p) => DateTime.tryParse(p.endDate ?? '')?.isAfter(now) ?? false)
              .toList()
            ..sort((a, b) {
              final aEndDate = DateTime.tryParse(a.endDate ?? '');
              final bEndDate = DateTime.tryParse(b.endDate ?? '');
              if (aEndDate == null || bEndDate == null) return 0;
              return aEndDate.compareTo(bEndDate);
            });

          final endedAuctions = state.products
              .where((p) => DateTime.tryParse(p.endDate ?? '')?.isBefore(now) ?? false)
              .toList();

          // Combine them with ongoing first
          final sortedProducts = [...ongoingAuctions, ...endedAuctions];

          final featuredProducts = sortedProducts.where((p) => p.isFeatured ?? false).toList();
          final nonFeaturedProducts = sortedProducts.where((p) => !(p.isFeatured ?? false)).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'featuredProducts'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (featuredProducts.isNotEmpty)
                  SizedBox(
                    height: 200, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredProducts.length,
                      itemBuilder: (context, index) {
                        final product = featuredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: AuctionProductCard(product: product),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  'latestAuctions'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: nonFeaturedProducts.length > 4 ? 4 : nonFeaturedProducts.length,
                  itemBuilder: (context, index) {
                    final product = nonFeaturedProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                      child: AuctionProductCard(product: product),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlocProvider(
                          create: (context) => ProductCubit(),
                          child: const AllProductsScreen(),
                        )),
                      );
                    },
                    child: Text('showAll'.tr()),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProductError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class AuctionProductCard extends StatefulWidget {
  final Products product;

  const AuctionProductCard({super.key, required this.product});

  @override
  _AuctionProductCardState createState() => _AuctionProductCardState();
}

class _AuctionProductCardState extends State<AuctionProductCard> {
  late Timer _timer;
  late Duration _timeRemaining;

  @override
  void initState() {
    super.initState();
    final endDate = DateTime.tryParse(widget.product.endDate ?? '');
    if (endDate != null) {
      _timeRemaining = endDate.difference(DateTime.now());
    } else {
      _timeRemaining = Duration.zero;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.inSeconds > 0) {
        if(mounted) {
          setState(() {
            _timeRemaining = _timeRemaining - const Duration(seconds: 1);
          });
        }
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds <= 0) {
      return 'auctionEnded'.tr();
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$daysي ${hours}س ${minutes}د ${seconds}ث';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: widget.product.imageUrl ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name ?? 'noName'.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${'currentPrice'.tr()}: \$${widget.product.currentPrice?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${'timeRemaining'.tr()}: ${_formatDuration(_timeRemaining)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _timeRemaining.inSeconds > 0 ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}