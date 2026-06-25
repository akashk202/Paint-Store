import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:c_h_p/features/explore/presentation/providers/explore_providers.dart';
import 'package:c_h_p/features/product/presentation/providers/product_providers.dart';

class LinkShadeProductPage extends ConsumerStatefulWidget {
  const LinkShadeProductPage({super.key});

  @override
  ConsumerState<LinkShadeProductPage> createState() => _LinkShadeProductPageState();
}

class _LinkShadeProductPageState extends ConsumerState<LinkShadeProductPage> {
  final TextEditingController _shadeSearch = TextEditingController();
  final TextEditingController _productSearch = TextEditingController();

  String _selectedShadeCode = '';
  String _selectedShadeName = '';
  String _selectedShadeHex = '#FFFFFF';

  String _productQuery = '';
  String _selectedProductId = '';
  String _selectedProductName = '';

  Map<String, dynamic>? _currentLink; // existing link for selected shade

  @override
  void initState() {
    super.initState();
    _productSearch.addListener(() => setState(() => _productQuery = _productSearch.text.trim()));
  }

  Future<void> _loadExistingLink() async {
    if (_selectedShadeCode.isEmpty) return;
    try {
      _currentLink = await ref.read(fetchShadeLinkUseCaseProvider).call(_selectedShadeCode);
    } catch (_) {
      _currentLink = null;
    }
    if (mounted) setState(() {});
  }

  Future<void> _unlink() async {
    if (_selectedShadeCode.isEmpty) return;
    try {
      await ref.read(removeShadeLinkUseCaseProvider).call(_selectedShadeCode);
      _currentLink = null;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unlinked')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to unlink: $e')));
    }
    if (mounted) setState(() {});
  }

  Future<void> _confirmAndLink() async {
    if (_selectedShadeCode.isEmpty || _selectedProductId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pick a shade and a product')));
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Link Shade', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'Link "$_selectedShadeName ($_selectedShadeCode)" to "$_selectedProductName"?\nThis will replace any existing link.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Link')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(setShadeLinkUseCaseProvider).call(_selectedShadeCode, {
        'productId': _selectedProductId,
        'productName': _selectedProductName,
        'shadeCode': _selectedShadeCode,
        'shadeName': _selectedShadeName,
        'timestamp': ServerValue.timestamp,
      });
      await _loadExistingLink();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Linked successfully')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncProducts = ref.watch(productsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Link Shade to Product', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.pink.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Selected shade banner
          if (_selectedShadeCode.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(width: 28, height: 28, decoration: BoxDecoration(color: _hexToColor(_selectedShadeHex), borderRadius: BorderRadius.circular(6))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$_selectedShadeName ($_selectedShadeCode)', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      if (_currentLink != null)
                        Text('Current: ${_currentLink!['productName']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ]),
                  ),
                  if (_currentLink != null)
                    IconButton(tooltip: 'Unlink', icon: const Icon(Iconsax.trash), onPressed: _unlink),
                ],
              ),
            ),

          // Step 1: Select shade (grid)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _shadeSearch,
              decoration: InputDecoration(
                hintText: 'Search shade by 4-digit code or name',
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: _shadeSearch.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close), onPressed: () { _shadeSearch.clear(); setState(() {}); })
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(
            height: 180,
            child: StreamBuilder<Map<String, dynamic>>(
              stream: ref.watch(getColorCategoriesStreamUseCaseProvider).call(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null || data.isEmpty) {
                  return const Center(child: Text('No catalog'));
                }
                final List<Map<String, String>> shades = [];
                data.forEach((categoryKey, shadesData) {
                  if (shadesData is Map) {
                    final familyShadesMap = Map<String, dynamic>.from(shadesData);
                    familyShadesMap.forEach((shadeCode, shadeDetails) {
                      if (shadeDetails is Map) {
                        final shade = Map<String, dynamic>.from(shadeDetails);
                        final m = {
                          'code': shadeCode.toString(),
                          'name': (shade['name'] ?? '').toString(),
                          'hex': (shade['hex'] ?? '#FFFFFF').toString(),
                        };
                        final q = _shadeSearch.text.trim().toLowerCase();
                        if (q.isEmpty || m['code']!.toLowerCase().contains(q) || m['name']!.toLowerCase().contains(q)) {
                          shades.add(m);
                        }
                      }
                    });
                  }
                });
                shades.sort((a, b) => a['name']!.compareTo(b['name']!));
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: shades.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final s = shades[i];
                    final isSelected = _selectedShadeCode == s['code'];
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          _selectedShadeCode = s['code']!;
                          _selectedShadeName = s['name']!;
                          _selectedShadeHex = s['hex']!;
                          _selectedProductId = '';
                          _selectedProductName = '';
                        });
                        await _loadExistingLink();
                      },
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 4))],
                          border: isSelected ? Border.all(color: Colors.deepOrange, width: 2) : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(color: _hexToColor(s['hex']!), borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(s['name']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                Text(s['code']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                              ]),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Step 2: Select product
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _productSearch,
              decoration: InputDecoration(
                hintText: 'Search product name',
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: _productSearch.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close), onPressed: () { _productSearch.clear(); setState(() {}); })
                    : null,
              ),
            ),
          ),
          Expanded(
            child: asyncProducts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
              data: (products) {
                final items = products
                    .where((p) => _productQuery.isEmpty || p.name.toLowerCase().contains(_productQuery.toLowerCase()))
                    .toList();
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final product = items[i];
                    final selected = _selectedProductId == product.key;
                    return ListTile(
                      title: Text(product.name, style: GoogleFonts.poppins()),
                      subtitle: Text(product.key, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
                      onTap: () => setState(() { _selectedProductId = product.key; _selectedProductName = product.name; }),
                    );
                  },
                );
              },
            ),
          ),

          // Primary Link action
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (_selectedShadeCode.isNotEmpty && _selectedProductId.isNotEmpty) ? _confirmAndLink : null,
                  icon: const Icon(Iconsax.link_2),
                  label: Text(_currentLink == null ? 'Link Shade to Product' : 'Replace Link', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String code) {
    try {
      final hex = code.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFFCCCCCC);
    }
  }
}
