import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:c_h_p/features/cart/presentation/providers/cart_providers.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';
import 'package:c_h_p/features/product/presentation/pages/product_detail_page.dart';
import 'package:c_h_p/features/cart/presentation/pages/cart_page.dart';

import '../providers/explore_providers.dart';
import '../../domain/entities/explore_product_entity.dart';
import '../mappers/explore_to_product_mapper.dart';

class SearchResultsPage extends ConsumerStatefulWidget {
  final String searchQuery;
  const SearchResultsPage({super.key, required this.searchQuery});

  @override
  ConsumerState<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchNotifierProvider.notifier).search(widget.searchQuery);
    });
  }

  Future<void> _addToCart(Product product) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final pack = product.packSizes.isNotEmpty ? product.packSizes.first : null;
      if (pack == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text("No pack sizes available for this product.")),
        );
        return;
      }

      final priceStr = pack.price.replaceAll(RegExp(r'[^0-9]'), '');

      await ref.read(cartNotifierProvider.notifier).addOrUpdateItem(
            productKey: product.key,
            name: product.name,
            imageUrl: product.mainImageUrl,
            size: pack.size,
            price: priceStr,
          );

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text("${product.name} added to cart!"),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text("Failed to add to cart: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Results for "${widget.searchQuery}"',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
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
      ),
      body: searchState.loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange))
          : searchState.results.isNotEmpty
              ? _buildResultsGridView(searchState.results)
              : _buildNoResultsView(searchState.suggestions),
    );
  }

  Widget _buildResultsGridView(List<ExploreProductEntity> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(context, exploreEntityToProduct(products[index]))
            .animate()
            .fade(duration: 500.ms, delay: (100 * index).ms)
            .slideY(begin: 0.2, curve: Curves.easeOut);
      },
    );
  }

  Widget _buildNoResultsView(List<ExploreProductEntity> suggestions) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Icon(Iconsax.search_status_1, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        Text('No Results Found',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('We couldn\'t find any products matching "${widget.searchQuery}".',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 14, color: Colors.grey.shade600)),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 40),
          Text('You Might Also Like',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suggestions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              return _buildProductCard(
                  context, exploreEntityToProduct(suggestions[index]));
            },
          ),
        ],
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final priceToShow = product.packSizes.isNotEmpty
        ? product.packSizes.first.price
        : 'N/A';

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Hero(
                  tag: 'product_image_${product.key}',
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: product.mainImageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 160),
                          memCacheWidth: 400,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade200),
                          errorWidget: (c, e, s) => const Center(
                              child: Icon(Iconsax.gallery_slash,
                                  size: 36, color: Colors.grey)),
                        ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('MRP \u20B9$priceToShow',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange)),
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: ElevatedButton(
                              onPressed: () => _addToCart(product),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Icon(Iconsax.shopping_bag, size: 18),
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
      ),
    );
  }
}
