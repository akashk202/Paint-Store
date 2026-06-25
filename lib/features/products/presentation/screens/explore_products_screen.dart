import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:c_h_p/features/products/presentation/bloc/product_bloc.dart';
import 'package:c_h_p/features/products/presentation/bloc/product_event.dart';
import 'package:c_h_p/features/products/presentation/bloc/product_state.dart';
import 'package:c_h_p/features/products/presentation/widgets/product_card.dart';
import 'package:c_h_p/features/products/domain/entities/product_entity.dart';

/// Explore products screen — uses BLoC exclusively.
/// Dispatches LoadProducts and SearchProducts events.
class ExploreProductsScreen extends StatefulWidget {
  const ExploreProductsScreen({super.key});

  @override
  State<ExploreProductsScreen> createState() => _ExploreProductsScreenState();
}

class _ExploreProductsScreenState extends State<ExploreProductsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load products when screen opens
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade200,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        title: Text(
          'Explore Products',
          style: GoogleFonts.poppins(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  if (query.trim().isEmpty) {
                    context.read<ProductBloc>().add(const ClearSearch());
                  } else {
                    context
                        .read<ProductBloc>()
                        .add(SearchProducts(query));
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade600, fontSize: 14),
                  prefixIcon: const Icon(Iconsax.search_normal_1,
                      color: Colors.grey, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: Colors.grey, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<ProductBloc>()
                                .add(const ClearSearch());
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 12),
                ),
              ),
            ),
          ),

          // Product grid
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepOrange),
                  );
                }

                if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.warning_2,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(state.message,
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade600),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<ProductBloc>()
                              .add(const LoadProducts()),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange),
                          child: Text('Retry',
                              style: GoogleFonts.poppins(
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }

                List<ProductEntity> products = [];
                String? searchQuery;

                if (state is ProductLoaded) {
                  products = state.products;
                } else if (state is ProductSearchResults) {
                  products = state.products;
                  searchQuery = state.query;
                }

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.box,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery != null
                              ? 'No products found for "$searchQuery"'
                              : 'No products available',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        // Navigate to product detail
                        // This will be connected once legacy pages
                        // are migrated or a new detail screen is built
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
