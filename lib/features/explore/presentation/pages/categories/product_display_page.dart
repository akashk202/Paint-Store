import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import 'package:c_h_p/features/product/data/models/product_model.dart';
import 'package:c_h_p/features/product/presentation/pages/product_detail_page.dart';
import 'package:c_h_p/features/cart/presentation/pages/cart_page.dart';
import 'package:c_h_p/features/explore/domain/entities/explore_product_entity.dart';
import 'package:c_h_p/features/explore/presentation/mappers/explore_to_product_mapper.dart';
import 'package:c_h_p/features/explore/presentation/providers/explore_providers.dart';

class ProductDisplayPage extends ConsumerStatefulWidget {
  final String title;
  final String? category;
  final String? subCategory;
  final String? brand;

  const ProductDisplayPage({
    super.key,
    required this.title,
    this.category,
    this.subCategory,
    this.brand,
  });

  @override
  ConsumerState<ProductDisplayPage> createState() => _ProductDisplayPageState();
}

class _ProductDisplayPageState extends ConsumerState<ProductDisplayPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sadReactionController;
  late final Animation<double> _sadBobY;
  late final Animation<double> _sadTilt;
  late final Animation<double> _sadShakeX;
  late final Animation<double> _sadScale;
  late final Animation<double> _sadOpacity;

  @override
  void initState() {
    super.initState();

    // Kick off the data load via the notifier (clean architecture)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDisplayNotifierProvider.notifier).loadProducts(
            category: widget.category,
            subCategory: widget.subCategory,
            brand: widget.brand,
          );
    });

    _sadReactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _sadBobY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -10.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -10.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 18,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 64),
    ]).animate(_sadReactionController);

    _sadShakeX = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 45),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -6.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -6.0, end: 6.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 7,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 6.0, end: -4.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 7,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -4.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 6,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 30),
    ]).animate(_sadReactionController);

    _sadTilt = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -0.07)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.07, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 30),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.05)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.05, end: -0.03)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.03, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 8,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 16),
    ]).animate(_sadReactionController);

    _sadScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.03)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.03, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 18,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 64),
    ]).animate(_sadReactionController);

    _sadOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.9)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 18,
      ),
      TweenSequenceItem(tween: ConstantTween(0.9), weight: 64),
    ]).animate(_sadReactionController);
  }

  @override
  void dispose() {
    _sadReactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayState = ref.watch(productDisplayNotifierProvider);

    final brandLower = (widget.brand ?? '').toLowerCase();
    final isIndigo = brandLower.startsWith('indigo');
    final isAsian = brandLower.startsWith('asian paints');
    final useLuxuryStyle = isIndigo || isAsian;

    return Scaffold(
      backgroundColor:
          useLuxuryStyle ? const Color(0xFFF8F9FA) : Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: useLuxuryStyle
              ? GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              : GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        backgroundColor: Colors.white,
        elevation: useLuxuryStyle ? 0 : 1,
        iconTheme: IconThemeData(
            color: useLuxuryStyle ? Colors.black87 : Colors.grey.shade800),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.shopping_cart),
            tooltip: 'Cart',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
          ),
        ],
        bottom: useLuxuryStyle
            ? PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(color: Colors.grey.shade200, height: 1.0),
              )
            : null,
      ),
      body: _buildBody(displayState),
    );
  }

  Widget _buildBody(dynamic displayState) {
    if (displayState.loading) {
      return _buildLoadingShimmer();
    }
    if (displayState.error != null) {
      return Center(child: Text("Error: ${displayState.error}"));
    }
    if (displayState.products.isEmpty) {
      return _buildEmptyState();
    }

    // Convert entities to Product models for the card widgets
    final products = displayState.products
        .map<Product>((ExploreProductEntity e) => exploreEntityToProduct(e))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      scrollCacheExtent: const ScrollCacheExtent.pixels(1200),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return KeyedSubtree(
          key: ValueKey('prod_${product.key}'),
          child: _buildProductListItem(context, product, index: index),
        );
      },
    );
  }

  Widget _buildProductListItem(BuildContext context, Product product,
      {int? index}) {
    String priceToShow = 'N/A';
    String smallestSizeLabel = '';
    if (product.packSizes.isNotEmpty) {
      double? minPrice;
      for (final ps in product.packSizes) {
        final cleaned = ps.price.replaceAll(RegExp('[^0-9\\.]'), '');
        final val = double.tryParse(cleaned);
        if (val != null) {
          if (minPrice == null || val < minPrice) minPrice = val;
        }
      }
      if (minPrice != null) {
        priceToShow = minPrice.toStringAsFixed(minPrice % 1 == 0 ? 0 : 2);
      }
      final sortedBySize = [...product.packSizes]
        ..sort((a, b) => a.numericSize.compareTo(b.numericSize));
      smallestSizeLabel = sortedBySize.first.size;
    }

    final brandLower = (product.brand ?? '').toLowerCase();
    final isIndigo = brandLower.startsWith('indigo');
    final isAsian = brandLower.startsWith('asian paints');
    if (isIndigo || isAsian) {
      return _buildLuxuryCard(context, product, priceToShow, smallestSizeLabel,
              index: index)
          .animate()
          .fadeIn(duration: 600.ms, delay: ((index ?? 0) * 120).ms)
          .moveX(begin: -24, duration: 600.ms, curve: Curves.easeOutCubic);
    }

    final defaultCard =
        _buildDefaultCard(context, product, priceToShow, smallestSizeLabel);

    if (isAsian) {
      return defaultCard
          .animate()
          .fadeIn(duration: 600.ms, delay: ((index ?? 0) * 120).ms)
          .moveX(begin: -24, duration: 600.ms, curve: Curves.easeOutCubic);
    }
    return defaultCard;
  }

  Widget _buildLuxuryCard(BuildContext context, Product product,
      String priceToShow, String smallestSizeLabel,
      {int? index}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductDetailPage(product: product),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 14,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Hero(
                tag: 'product_image_${product.key}',
                child: CachedNetworkImage(
                  imageUrl: product.mainImageUrl,
                  fit: BoxFit.cover,
                  width: 130,
                  height: double.infinity,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey.shade100),
                  errorWidget: (c, e, s) => Container(
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Icon(Iconsax.gallery_slash,
                          size: 40, color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (smallestSizeLabel.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.deepOrange.shade100),
                            ),
                            child: Text(smallestSizeLabel,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.deepOrange.shade700)),
                          ),
                        if (smallestSizeLabel.isNotEmpty)
                          const SizedBox(width: 8),
                        Text(
                          'MRP  \u20B9$priceToShow',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.deepOrange.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Iconsax.arrow_right_3, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCard(BuildContext context, Product product,
      String priceToShow, String smallestSizeLabel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withAlpha(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProductDetailPage(product: product),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Hero(
                tag: 'product_image_${product.key}',
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.white,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: product.mainImageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 160),
                          memCacheWidth: 300,
                          memCacheHeight: 300,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade200),
                          errorWidget: (c, e, s) =>
                              const Center(child: Icon(Iconsax.gallery_slash)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade600, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (smallestSizeLabel.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.deepOrange.shade100),
                            ),
                            child: Text(smallestSizeLabel,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.deepOrange.shade700)),
                          ),
                        if (smallestSizeLabel.isNotEmpty)
                          const SizedBox(width: 8),
                        Text(
                          'MRP  \u20B9$priceToShow',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.deepOrange.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Iconsax.arrow_right_3, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _sadReactionController,
              child: Text('\u{1F61E}', style: GoogleFonts.poppins(fontSize: 72)),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_sadShakeX.value, _sadBobY.value),
                  child: Transform.rotate(
                    angle: _sadTilt.value,
                    child: Transform.scale(
                      scale: _sadScale.value,
                      child: Opacity(
                        opacity: _sadOpacity.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              "No Products Found",
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            Text(
              "It seems there are no products available in this category at the moment. Please check back later!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 20,
                            width: double.infinity,
                            color: Colors.white),
                        const SizedBox(height: 8),
                        Container(
                            height: 14,
                            width: double.infinity,
                            color: Colors.white),
                        const SizedBox(height: 4),
                        Container(height: 14, width: 150, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 18, width: 80, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
