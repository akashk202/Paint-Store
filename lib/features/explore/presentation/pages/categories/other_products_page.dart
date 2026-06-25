import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import 'package:c_h_p/features/product/data/models/product_model.dart';
import 'package:c_h_p/features/product/presentation/pages/product_detail_page.dart';
import 'package:c_h_p/features/explore/presentation/providers/explore_providers.dart';
import 'package:c_h_p/features/explore/presentation/mappers/explore_to_product_mapper.dart';

class OtherProductsPage extends ConsumerStatefulWidget {
  const OtherProductsPage({super.key});

  @override
  ConsumerState<OtherProductsPage> createState() => _OtherProductsPageState();
}

class _OtherProductsPageState extends ConsumerState<OtherProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDisplayNotifierProvider.notifier).loadProducts(
            category: 'Others',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDisplayNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Other Products",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: state.loading
          ? _buildLoadingShimmer()
          : state.error != null
              ? const Center(child: Text("Error loading products."))
              : state.products.isEmpty
                  ? const Center(child: Text("No 'Other' products found."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product =
                            exploreEntityToProduct(state.products[index]);
                        return _buildProductListItem(context, product);
                      },
                    ),
    );
  }

  Widget _buildProductListItem(BuildContext context, Product product) {
    final priceToShow = product.packSizes.isNotEmpty
        ? product.packSizes.first.price
        : 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: product.mainImageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey.shade200),
                  errorWidget: (context, url, error) =>
                      const Icon(Iconsax.gallery_slash),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'MRP \n\u20B9$priceToShow',
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade700),
              ),
            ],
          ),
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
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: SizedBox(width: 70, height: 70, child: Card()),
              title: SizedBox(height: 20, child: Card()),
              subtitle: SizedBox(height: 30, child: Card()),
            ),
          );
        },
      ),
    );
  }
}