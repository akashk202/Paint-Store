import 'package:c_h_p/features/admin/presentation/pages/add_product_page.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';
import 'package:c_h_p/features/product/presentation/pages/edit_product_page.dart';
import 'package:c_h_p/features/product/presentation/providers/product_providers.dart';
import 'package:c_h_p/features/product/presentation/providers/product_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Ensure the class name matches your file name and usage
class ManageProductsPage extends ConsumerStatefulWidget {
  const ManageProductsPage({super.key});

  @override
  ConsumerState<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends ConsumerState<ManageProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _showDeleteDialog(String key, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete "$name"? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () async {
              final success = await ref.read(productNotifierProvider.notifier).deleteProduct(key);
              if (mounted) {
                Navigator.of(ctx).pop();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('"$name" has been deleted.'),
                        backgroundColor: Colors.red),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('Failed to delete product.'),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Manage Products",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by product name...',
                prefixIcon: const Icon(Iconsax.search_normal_1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          // --- PRODUCT LIST ---
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final asyncProducts = ref.watch(productsStreamProvider);
                
                return asyncProducts.when(
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: Colors.deepOrange)),
                  error: (error, stack) => Center(
                      child: Text("Error loading products: $error")),
                  data: (List<Product> allProducts) {
                    if (allProducts.isEmpty) {
                      return const Center(
                          child:
                              Text("No products found. Add one to get started!"));
                    }

                    // Filter based on the Product object's name
                    final filteredProducts = allProducts.where((product) {
                      return product.name.toLowerCase().contains(_searchQuery);
                    }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                      child: Text("No products match your search."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      16, 16, 16, 100), // Padding includes FAB space
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(
                        product, product.toMap()); // Pass both product and raw data
                  },
                );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProductPage()));
        },
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Iconsax.add, color: Colors.white),
        label: Text("Add Product",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // Ã¢Â­Â 3. UPDATED CARD WIDGET to use Product object
  Widget _buildProductCard(
      Product product, Map<String, dynamic> rawProductData) {
    int stock = product.stock;
    Color stockColor;
    if (stock == 0) {
      stockColor = Colors.red.shade700;
    } else if (stock <= 10) {
      stockColor = Colors.orange.shade800;
    } else {
      stockColor = Colors.green.shade800;
    }

    // Get the price of the first pack size to display
    final priceToShow =
        product.packSizes.isNotEmpty ? product.packSizes.first.price : 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          // Ã¢Â­Â Use mainImageUrl from Product object
                          imageUrl: product.mainImageUrl,
                          fit: BoxFit.contain,
                          fadeInDuration: const Duration(milliseconds: 160),
                          memCacheWidth: 220,
                          memCacheHeight: 220,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade200),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Iconsax.gallery_slash)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Ã¢Â­Â Use name from Product object
                        product.name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // ⭐ Use brand from Product object
                        "Brand: ${product.brand ?? 'N/A'}",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Stock: $stock",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: stockColor)),
                    // Ã¢Â­Â Display starting price from pack sizes
                    Text("MRP : Ã¢â€šÂ¹$priceToShow",
                        style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.edit,
                          color: Colors.blue, size: 20),
                      onPressed: () => Navigator.push(
                        context,
                        // Pass the raw data map to EditProductPage
                        MaterialPageRoute(
                            builder: (_) => EditProductPage(
                                productKey: product.key,
                                productData: rawProductData)),
                      ),
                      tooltip: 'Edit Product',
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.trash,
                          color: Colors.red, size: 20),
                      // Ã¢Â­Â Use key and name from Product object
                      onPressed: () =>
                          _showDeleteDialog(product.key, product.name),
                      tooltip: 'Delete Product',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
