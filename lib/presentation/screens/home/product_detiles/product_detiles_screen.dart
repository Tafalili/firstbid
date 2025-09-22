import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../pdoudict_detiles/product_details_cubit.dart';
import '../product_cubit/products.dart';
class ProductDetailsScreen extends StatefulWidget {
  final Products product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _controller = PageController();
  late Timer _timer;
  late Duration _timeRemaining;
  int _currentIndex = 0;
  num _bidAmount = 0;

  @override
  void initState() {
    super.initState();
    _bidAmount = widget.product.currentPrice ?? 0;
    // Parse the end_date and calculate the time remaining
    final endDate = DateTime.tryParse(widget.product.endDate ?? '');
    if (endDate != null) {
      _timeRemaining = endDate.difference(DateTime.now());
    } else {
      _timeRemaining = Duration.zero;
    }

    // Update the timer every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.inSeconds > 0) {
        if (mounted) {
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
    _controller.dispose();
    context.read<ProductDetailsCubit>().disposeRealtimeSubscription();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name ?? 'noName'.tr()),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Implement add to favorites functionality
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ProductDetailsCubit()..fetchProductDetails(widget.product.id!),
        child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
          listener: (context, state) {
            if (state is ProductDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailsSuccess) {
              final product = state.product;
              final bids = state.bids;
              _bidAmount = product.currentPrice ?? 0;
              final description = context.locale.languageCode == 'ar'
                  ? product.descriptionAr
                  : product.descriptionEn;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Carousel
                      SizedBox(
                        height: 300,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              controller: _controller,
                              itemCount: product.imageUrls?.length ?? 1,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrls?[index] ?? product.imageUrl ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 10,
                              child: SmoothPageIndicator(
                                controller: _controller,
                                count: product.imageUrls?.length ?? 1,
                                effect: const SwapEffect(
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.grey,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  spacing: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Product Name and Bid Section
                      Text(
                        product.name ?? 'noName'.tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'currentPrice'.tr(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '\$${product.currentPrice?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    _bidAmount++;
                                  });
                                },
                              ),
                              Text(
                                '$_bidAmount',
                                style: const TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (_bidAmount > (product.currentPrice ?? 0)) {
                                    setState(() {
                                      _bidAmount--;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProductDetailsCubit>().placeBid(product.id!, _bidAmount);
                            },
                            child: Text('placeBid'.tr()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Countdown Timer
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatDuration(_timeRemaining),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Bidder Info Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.emoji_events, color: Colors.amber),
                                    const SizedBox(width: 8),
                                    Text(
                                      'highestBidder'.tr(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // TODO: Implement the dropdown list of all bidders
                            if (bids.isNotEmpty)
                              Text('Highest Bid: \$${bids.first.bidAmount?.toStringAsFixed(2)} by ${bids.first.profiles?.fullName ?? 'Anonymous'}'),

                            if (bids.isEmpty)
                              Text('noBids'.tr()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Product Details Section
                      Text(
                        'productDetails'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: Text('status'.tr()),
                        subtitle: Text(product.status ?? 'unknownStatus'.tr()),
                      ),
                      ListTile(
                        title: Text('productNumber'.tr()),
                        subtitle: Text(product.serialNumber ?? 'unknownNumber'.tr()),
                      ),
                      ListTile(
                        title: Text('originalPrice'.tr()),
                        subtitle: Text('\$${product.originalPrice?.toStringAsFixed(2) ?? '0.00'}'),
                      ),
                      const SizedBox(height: 16),
                      // Description Section
                      ExpansionTile(
                        title: Text('description'.tr()),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              description ?? 'noDescription'.tr(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(child: Text('error'.tr()));
          },
        ),
      ),
    );
  }
}