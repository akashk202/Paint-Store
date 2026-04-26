import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:c_h_p/features/product/data/models/product_model.dart';
import 'package:c_h_p/features/product/presentation/pages/product_detail_page.dart';
import 'package:c_h_p/features/cart/presentation/pages/cart_page.dart';
import 'package:c_h_p/features/cart/presentation/providers/cart_providers.dart';
import 'package:c_h_p/features/explore/presentation/providers/explore_providers.dart';
import 'package:c_h_p/features/explore/presentation/mappers/explore_to_product_mapper.dart';

class EconomyPage extends ConsumerStatefulWidget {
  const EconomyPage({super.key});

  @override
  ConsumerState<EconomyPage> createState() => _EconomyPageState();
}

class _EconomyPageState extends ConsumerState<EconomyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDisplayNotifierProvider.notifier).loadProducts(
            subCategory: 'Economy',
          );
    });
  }

  Future<void> _addToCart(Product product) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please log in to add items to your cart.")),
      );
      return;
    }

    final firstSize =
        product.packSizes.isNotEmpty ? product.packSizes.first.size : '';
    final firstPrice =
        product.packSizes.isNotEmpty ? product.packSizes.first.price : '0';

    try {
      await ref.read(cartNotifierProvider.notifier).addOrUpdateItem(
            productKey: product.key,
            name: product.name,
            imageUrl: product.mainImageUrl,
            size: firstSize,
            price: firstPrice,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.name} added to cart!"),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add to cart: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDisplayNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Economy Paints",
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: state.loading
          ? _buildLoadingShimmer()
          : state.error != null
              ? _buildErrorState()
              : state.products.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product =
                            exploreEntityToProduct(state.products[index]);
                        return _buildProductCard(context, product)
                            .animate()
                            .fadeIn(
                                duration: 600.ms, delay: (150 * index).ms)
                            .moveX(
                                begin: -30,
                                duration: 600.ms,
                                curve: Curves.easeOutCubic);
                      },
                    ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final priceToShow =
        product.packSizes.isNotEmpty ? product.packSizes.first.price : 'N/A';

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
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
                          size: 40, color: Colors.grey.shade400)),
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
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Starts at \u20B9$priceToShow',
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3A3A3A)),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () => _addToCart(product),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Icon(Iconsax.shopping_bag, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            Icon(Iconsax.box_search, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text(
              "No Products Available",
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              "It seems there are no products in this category at the moment.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 20),
            Text(
              "Something Went Wrong",
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn't load the products. Please check your connection and try again.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
