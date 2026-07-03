import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/visualizer_providers.dart';
import '../providers/visualizer_notifier.dart';
import '../../../explore/presentation/providers/explore_providers.dart';
import '../../../explore/presentation/providers/color_catalogue_state.dart';
import '../../../explore/domain/entities/color_shade.dart';

class VisualizerPage extends ConsumerStatefulWidget {
  const VisualizerPage({super.key});

  @override
  ConsumerState<VisualizerPage> createState() => _VisualizerPageState();
}

class _VisualizerPageState extends ConsumerState<VisualizerPage> {
  @override
  void initState() {
    super.initState();
    // Load the color catalogue shades from the repository on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(colorCatalogueNotifierProvider.notifier).loadShades();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(visualizerNotifierProvider);
    final catalogueState = ref.watch(colorCatalogueNotifierProvider);

    // Listen for error messages and display them as Snackbars
    ref.listen(visualizerNotifierProvider.select((s) => s.error), (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next, style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    // Listen for save notifications and show a success dialog
    ref.listen(visualizerNotifierProvider.select((s) => s.savePath), (prev, next) {
      if (next != null) {
        _showSaveSuccessDialog(context, next);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Paint Visualizer Studio',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: state.isValidated
            ? IconButton(
                icon: const Icon(Iconsax.arrow_left, color: Colors.black87),
                onPressed: () {
                  ref.read(visualizerNotifierProvider.notifier).clearImage();
                },
              )
            : null,
        actions: state.isValidated
            ? [
                IconButton(
                  icon: Icon(
                    Iconsax.undo,
                    color: state.undoHistory.isNotEmpty ? Colors.black87 : Colors.grey.shade300,
                  ),
                  tooltip: 'Undo Last Action',
                  onPressed: state.undoHistory.isNotEmpty
                      ? () => ref.read(visualizerNotifierProvider.notifier).undoLastStroke()
                      : null,
                ),
                IconButton(
                  icon: const Icon(Iconsax.document_download, color: Colors.black87),
                  tooltip: 'Save to Gallery',
                  onPressed: () => ref.read(visualizerNotifierProvider.notifier).saveToGallery(),
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          // 1. Initial State / Empty View
          if (!state.isValidated && !state.isValidating && !state.isValidationFailed)
            _buildIntroView(context),

          // 2. Validation Scanning View
          if (state.isValidating)
            _buildScanningView(state.originalImageBytes),

          // 3. Validation Failed View
          if (state.isValidationFailed)
            _buildValidationFailedView(state.validationMessage),

          // 4. Painting Canvas Studio View
          if (state.isValidated)
            _buildPaintingCanvasView(state, catalogueState),

          // 5. Global Loading Overlay (during painting/saving)
          if (state.isInitializing || state.isSaving)
            Container(
              color: Colors.black26,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.deepOrange),
                        const SizedBox(height: 16),
                        Text(
                          state.isSaving ? 'Saving design...' : 'Applying paint colors...',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build the initial intro view before picking a photo
  Widget _buildIntroView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey.shade50, Colors.white],
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Beautiful Icon Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.brush_3,
                  size: 72,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'AI Paint Studio',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Visualize real brand colors in your home instantly. Tap to paint specific surfaces while preserving highlights and textures realistically.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // Action Cards
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Iconsax.gallery,
                      title: 'Gallery',
                      subtitle: 'Choose existing photo',
                      color: Colors.deepOrange,
                      onTap: () => ref
                          .read(visualizerNotifierProvider.notifier)
                          .importAndValidateImage(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      icon: Iconsax.camera,
                      title: 'Camera',
                      subtitle: 'Take a new photo',
                      color: Colors.indigo,
                      onTap: () => ref
                          .read(visualizerNotifierProvider.notifier)
                          .importAndValidateImage(ImageSource.camera),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Tip: For best results, choose a well-lit photo of a room wall or house building exterior.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  // Scanning simulation view
  Widget _buildScanningView(Uint8List? imageBytes) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageBytes != null) Image.memory(imageBytes, fit: BoxFit.cover),
        const Positioned.fill(child: _ScanningOverlay()),
      ],
    );
  }

  // Rejection/Failure View
  Widget _buildValidationFailedView(String? message) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.shield_cross,
                size: 64,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Invalid Photo Structure',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'No walls or house facades detected. Please make sure your image contains walls, structural building features, or standard interior room details.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(visualizerNotifierProvider.notifier).clearImage();
              },
              icon: const Icon(Iconsax.refresh, color: Colors.white),
              label: Text('Try Another Photo', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Interactive paint canvas with bottom Color Studio control panel
  Widget _buildPaintingCanvasView(VisualizerState state, ColorCatalogueState catalogueState) {
    final activeBytes = state.processedImageBytes ?? state.workingImageBytes;
    if (activeBytes == null) return const SizedBox();

    return Column(
      children: [
        // Instructions Bar
        Container(
          width: double.infinity,
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.info_circle, size: 16, color: Colors.deepOrange),
              const SizedBox(width: 8),
              Text(
                'Tap on any wall or building surface to paint it.',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

        // Photo Canvas
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTapUp: (details) {
                  ref.read(visualizerNotifierProvider.notifier).paintAtPosition(
                        localX: details.localPosition.dx,
                        localY: details.localPosition.dy,
                        containerWidth: constraints.maxWidth,
                        containerHeight: constraints.maxHeight,
                      );
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Image.memory(
                    activeBytes,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),

        // Color Studio Bottom Panel
        _buildColorStudioPanel(state, catalogueState),
      ],
    );
  }

  // Beautiful bottom control panel that integrates catalogue and AI advice
  Widget _buildColorStudioPanel(VisualizerState state, ColorCatalogueState catalogueState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, -5))
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Controls (Combination Mode Toggle + AI Advisor Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Combination Mode Switch
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 22,
                    color: state.isCombinationMode ? Colors.deepOrange : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Two-Tone Combinations',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        state.isCombinationMode ? 'Enabled (Paint different walls)' : 'Disabled (Single color)',
                        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: state.isCombinationMode,
                activeThumbColor: Colors.deepOrange,
                onChanged: (val) {
                  ref.read(visualizerNotifierProvider.notifier).toggleCombinationMode(val);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Paint Sensitivity Slider
          Row(
            children: [
              Icon(
                Icons.tune_outlined,
                size: 20,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                'Paint Sensitivity',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                  ),
                  child: Slider(
                    value: state.tolerance,
                    min: 5.0,
                    max: 75.0,
                    activeColor: Colors.deepOrange,
                    inactiveColor: Colors.grey.shade200,
                    onChanged: (val) {
                      ref.read(visualizerNotifierProvider.notifier).updateTolerance(val);
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${state.tolerance.round()}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Two-Tone Slots Display (if combination mode is on)
          if (state.isCombinationMode) ...[
            Row(
              children: [
                Expanded(
                  child: _buildColorSlot(
                    isActive: state.activeShadeSlot == 1,
                    label: 'Primary Wall',
                    shade: state.primaryShade,
                    onTap: () => ref.read(visualizerNotifierProvider.notifier).setActiveSlot(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSlot(
                    isActive: state.activeShadeSlot == 2,
                    label: 'Accent / Corridor',
                    shade: state.secondaryShade,
                    onTap: () => ref.read(visualizerNotifierProvider.notifier).setActiveSlot(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Horizontal Category Filter
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catalogueState.categories.length,
              itemBuilder: (context, index) {
                final cat = catalogueState.categories[index];
                final isSelected = catalogueState.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.deepOrange,
                    backgroundColor: Colors.grey.shade100,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (val) {
                      if (val) {
                        ref.read(colorCatalogueNotifierProvider.notifier).selectCategory(cat);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Color Swatches List and Ask AI Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Colors List
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: catalogueState.loading
                      ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                      : catalogueState.filteredShades.isEmpty
                          ? Center(
                              child: Text(
                                'No colors found in this category',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: catalogueState.filteredShades.length,
                              itemBuilder: (context, index) {
                                final shade = catalogueState.filteredShades[index];
                                final isSelected = (state.isCombinationMode
                                        ? (state.activeShadeSlot == 1
                                            ? state.primaryShade?.code == shade.code
                                            : state.secondaryShade?.code == shade.code)
                                        : state.primaryShade?.code == shade.code);

                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: InkWell(
                                    onTap: () {
                                      ref.read(visualizerNotifierProvider.notifier).selectShade(shade);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _parseHexColor(shade.hex),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                            border: Border.all(
                                              color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
                                              width: isSelected ? 3.0 : 1.0,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                                              : null,
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            shade.name,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),

              // Divider
              Container(
                height: 50,
                width: 1,
                color: Colors.grey.shade200,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),

              // Sparkle AI Button
              InkWell(
                onTap: () => _openAiRecommendationsSheet(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.shade100),
                  ),
                  child: const Column(
                    children: [
                      Icon(Iconsax.magicpen, color: Colors.indigo, size: 24),
                      SizedBox(height: 4),
                      Text(
                        'AI Advisor',
                        style: TextStyle(fontSize: 9, color: Colors.indigo, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSlot({
    required bool isActive,
    required String label,
    required ColorShade? shade,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepOrange.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.deepOrange : Colors.grey.shade200,
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: shade != null ? _parseHexColor(shade.hex) : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500),
                  ),
                  Text(
                    shade?.name ?? 'Choose Shade',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: shade != null ? Colors.grey.shade800 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Opens the Gemini Color Recommendations bottom sheet
  void _openAiRecommendationsSheet(BuildContext context) {
    ref.read(visualizerNotifierProvider.notifier).askAiAdvisor();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final visualizerState = ref.watch(visualizerNotifierProvider);
                
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Iconsax.magicpen, color: Colors.indigo, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            'AI Color Advisor',
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gemini 2.5 Flash analyzed your room photo and generated custom brand palettes based on lighting and furniture styling.',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        child: _buildAiRecommendationsContent(visualizerState, scrollController),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAiRecommendationsContent(VisualizerState state, ScrollController scrollController) {
    if (state.loadingAiSuggestions) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.indigo),
            SizedBox(height: 16),
            Text('Gemini is generating matching paint schemes...'),
          ],
        ),
      );
    }

    if (state.aiError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.warning_2, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                state.aiError!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.read(visualizerNotifierProvider.notifier).askAiAdvisor(),
                icon: const Icon(Iconsax.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              ),
            ],
          ),
        ),
      );
    }

    if (state.aiRecommendations.isEmpty) {
      return const Center(child: Text('No recommendations found.'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: state.aiRecommendations.length,
      itemBuilder: (context, index) {
        final rec = state.aiRecommendations[index];
        final primName = rec['primaryName'] ?? 'Primary Shade';
        final primHex = rec['primaryHex'] ?? '#CCCCCC';
        final secName = rec['secondaryName'] ?? 'Secondary Shade';
        final secHex = rec['secondaryHex'] ?? '#EAEAEA';
        final reason = rec['reason'] ?? 'No reason provided.';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          color: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display swatches Side by Side
                Row(
                  children: [
                    _buildMiniSwatch(primName, primHex, 'Primary'),
                    const SizedBox(width: 16),
                    const Icon(Iconsax.add, size: 16, color: Colors.grey),
                    const SizedBox(width: 16),
                    _buildMiniSwatch(secName, secHex, 'Accent'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  reason,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700, height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final primShade = ColorShade(category: 'AI Recommendation', code: 'AI-P', name: primName, hex: primHex);
                      final secShade = ColorShade(category: 'AI Recommendation', code: 'AI-S', name: secName, hex: secHex);

                      ref.read(visualizerNotifierProvider.notifier).toggleCombinationMode(true);
                      ref.read(visualizerNotifierProvider.notifier).selectShade(primShade);
                      ref.read(visualizerNotifierProvider.notifier).setActiveSlot(2);
                      ref.read(visualizerNotifierProvider.notifier).selectShade(secShade);
                      ref.read(visualizerNotifierProvider.notifier).setActiveSlot(1);

                      Navigator.pop(context); // close sheet
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Palette applied! Tap on different walls to paint.', style: GoogleFonts.poppins()),
                          backgroundColor: Colors.indigo,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Apply Combination', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniSwatch(String name, String hex, String role) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _parseHexColor(hex),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role, style: TextStyle(fontSize: 8, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            Text(name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          ],
        ),
      ],
    );
  }

  void _showSaveSuccessDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Iconsax.tick_circle, color: Colors.green, size: 28),
            const SizedBox(width: 10),
            Text('Saved to Gallery', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your high-definition painted design has been saved successfully.', style: GoogleFonts.poppins()),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Text(path, style: const TextStyle(fontSize: 10, color: Colors.black54)),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear state savePath to prevent repeated dialogs on rebuilds
              ref.read(visualizerNotifierProvider.notifier).clearImage();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.deepOrange),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Color _parseHexColor(String hex) {
    try {
      String clean = hex.trim().replaceAll('#', '');
      if (clean.length == 6) {
        clean = 'FF$clean';
      }
      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return Colors.red;
    }
  }
}

// Stateful scanning animation helper
class _ScanningOverlay extends StatefulWidget {
  const _ScanningOverlay();

  @override
  State<_ScanningOverlay> createState() => _ScanningOverlayState();
}

class _ScanningOverlayState extends State<_ScanningOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Dark overlay
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
            // Glowing laser scanning line
            Align(
              alignment: Alignment(0, -1.0 + (_controller.value * 2.0)),
              child: Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withValues(alpha: 0.8),
                      blurRadius: 15,
                      spreadRadius: 4,
                    )
                  ],
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Colors.deepOrange, Colors.transparent],
                  ),
                ),
              ),
            ),
            // Floating scan box
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.deepOrange, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.deepOrange),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AI Scanning Structures...',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
