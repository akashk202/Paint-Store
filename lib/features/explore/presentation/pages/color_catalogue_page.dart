import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:c_h_p/features/product/data/models/product_model.dart';
import 'package:c_h_p/features/product/presentation/pages/product_detail_page.dart';
import 'package:c_h_p/features/explore/presentation/providers/explore_providers.dart';
import 'package:c_h_p/features/explore/data/datasources/color_catalogue_remote_datasource.dart';

Color hexToColor(String code) {
  try {
    final hex = code.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return Colors.grey.shade300;
  } catch (e) {
    return Colors.grey.shade300;
  }
}

//==============================================================================
// Main Color Catalogue Page — now uses ConsumerStatefulWidget + Riverpod
//==============================================================================

class ColorCataloguePage extends ConsumerStatefulWidget {
  const ColorCataloguePage({super.key});

  @override
  ConsumerState<ColorCataloguePage> createState() =>
      _ColorCataloguePageState();
}

class _ColorCataloguePageState extends ConsumerState<ColorCataloguePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(colorCatalogueNotifierProvider.notifier).loadShades();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(colorCatalogueNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Color Catalogue",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: state.loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange))
          : state.error != null
              ? Center(child: Text("Error: ${state.error}"))
              : state.allShades.isEmpty
                  ? const Center(child: Text("Color catalogue is empty."))
                  : Column(
                      children: [
                        _buildFilterBar(state.categories, state.selectedCategory),
                        Expanded(child: _buildShadesGrid(state.filteredShades)),
                      ],
                    ),
    );
  }

  Widget _buildFilterBar(List<String> categories, String selectedCategory) {
    if (categories.length <= 1) return const SizedBox.shrink();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(colorCatalogueNotifierProvider.notifier)
                      .selectCategory(category);
                }
              },
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.deepOrange,
              ),
              selectedColor: Colors.deepOrange,
              backgroundColor: Colors.deepOrange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.deepOrange.shade100),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShadesGrid(List<ColorShadeModel> shades) {
    if (shades.isEmpty) {
      return const Center(child: Text("No shades found in this category."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: shades.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final shade = shades[index];
        return _buildColorSwatch(context, shade);
      },
    ).animate().fade(duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildColorSwatch(BuildContext context, ColorShadeModel shade) {
    final color = hexToColor(shade.hex);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ShadeDetailPage(shade: shade.toMap())),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shade.name,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey.shade800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            shade.code,
            style:
                GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

//==============================================================================
// Shade Detail Page — now uses ConsumerWidget + data source provider
//==============================================================================
class ShadeDetailPage extends ConsumerWidget {
  final Map<String, String> shade;
  const ShadeDetailPage({super.key, required this.shade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String shadeName = shade['name'] ?? 'Unnamed';
    final String shadeCode = shade['code'] ?? 'N/A';
    final Color color = hexToColor(shade['hex'] ?? '#FFFFFF');

    return Scaffold(
      appBar: AppBar(
        title: Text(shadeName,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(color: color),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDetailRow('Shade Name', shadeName),
                const SizedBox(height: 16),
                _buildDetailRow('Shade Code', shadeCode),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    // Use the data source via provider instead of direct Firebase
                    final dataSource =
                        ref.read(colorCatalogueDataSourceProvider);
                    final code = shade['code']?.toString() ?? '';
                    final linkedProduct =
                        await dataSource.resolveLinkedProduct(code);

                    if (linkedProduct != null) {
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailPage(product: linkedProduct)),
                      );
                      return;
                    }

                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ProductListForShadePage(shadeName: shadeName)),
                    );
                  },
                  child: Text('Find Products in this Shade',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800)),
      ],
    );
  }
}

//==============================================================================
// Product List for Shade Page — now uses ConsumerStatefulWidget
//==============================================================================
class ProductListForShadePage extends ConsumerStatefulWidget {
  final String shadeName;
  const ProductListForShadePage({super.key, required this.shadeName});

  @override
  ConsumerState<ProductListForShadePage> createState() =>
      _ProductListForShadePageState();
}

class _ProductListForShadePageState
    extends ConsumerState<ProductListForShadePage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Use the data source via provider
    final dataSource = ref.read(colorCatalogueDataSourceProvider);
    _productsFuture = dataSource.fetchProductsByShadeName(widget.shadeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Products in ${widget.shadeName}",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.deepOrange));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductListItem(context, products[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.box_search, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No products found for this shade.',
            style:
                GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: product.mainImageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (c, e, s) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Iconsax.gallery_slash)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade600, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}
