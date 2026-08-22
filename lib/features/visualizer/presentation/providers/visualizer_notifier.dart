import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:ui' as ui;

import '../../../explore/domain/entities/color_shade.dart';
import 'local_recolor_helper.dart';
import 'gemini_advisor_service.dart';

class VisualizerState {
  final bool isInitializing;
  final bool isValidating;
  final bool isValidated;
  final bool isValidationFailed;
  final String? validationMessage;
  final Uint8List? originalImageBytes;
  final Uint8List? workingImageBytes;
  final Uint8List? processedImageBytes;
  
  final ColorShade? primaryShade;
  final ColorShade? secondaryShade;
  final int activeShadeSlot; // 1 = Primary, 2 = Secondary
  final bool isCombinationMode;

  final List<Uint8List> undoHistory;
  final List<Map<String, dynamic>> aiRecommendations;
  final bool loadingAiSuggestions;
  final String? aiError;
  final bool isSaving;
  final String? savePath;
  final String? error;
  final double tolerance;

  const VisualizerState({
    this.isInitializing = false,
    this.isValidating = false,
    this.isValidated = false,
    this.isValidationFailed = false,
    this.validationMessage,
    this.originalImageBytes,
    this.workingImageBytes,
    this.processedImageBytes,
    this.primaryShade,
    this.secondaryShade,
    this.activeShadeSlot = 1,
    this.isCombinationMode = false,
    this.undoHistory = const [],
    this.aiRecommendations = const [],
    this.loadingAiSuggestions = false,
    this.aiError,
    this.isSaving = false,
    this.savePath,
    this.error,
    this.tolerance = 25.0,
  });

  VisualizerState copyWith({
    bool? isInitializing,
    bool? isValidating,
    bool? isValidated,
    bool? isValidationFailed,
    String? validationMessage,
    Uint8List? originalImageBytes,
    Uint8List? workingImageBytes,
    Uint8List? processedImageBytes,
    ColorShade? primaryShade,
    ColorShade? secondaryShade,
    int? activeShadeSlot,
    bool? isCombinationMode,
    List<Uint8List>? undoHistory,
    List<Map<String, dynamic>>? aiRecommendations,
    bool? loadingAiSuggestions,
    String? aiError,
    bool? isSaving,
    String? savePath,
    String? error,
    double? tolerance,
  }) {
    return VisualizerState(
      isInitializing: isInitializing ?? this.isInitializing,
      isValidating: isValidating ?? this.isValidating,
      isValidated: isValidated ?? this.isValidated,
      isValidationFailed: isValidationFailed ?? this.isValidationFailed,
      validationMessage: validationMessage ?? this.validationMessage,
      originalImageBytes: originalImageBytes ?? this.originalImageBytes,
      workingImageBytes: workingImageBytes ?? this.workingImageBytes,
      processedImageBytes: processedImageBytes ?? this.processedImageBytes,
      primaryShade: primaryShade ?? this.primaryShade,
      secondaryShade: secondaryShade ?? this.secondaryShade,
      activeShadeSlot: activeShadeSlot ?? this.activeShadeSlot,
      isCombinationMode: isCombinationMode ?? this.isCombinationMode,
      undoHistory: undoHistory ?? this.undoHistory,
      aiRecommendations: aiRecommendations ?? this.aiRecommendations,
      loadingAiSuggestions: loadingAiSuggestions ?? this.loadingAiSuggestions,
      aiError: aiError ?? this.aiError,
      isSaving: isSaving ?? this.isSaving,
      savePath: savePath ?? this.savePath,
      error: error ?? this.error,
      tolerance: tolerance ?? this.tolerance,
    );
  }

  static VisualizerState initial() => const VisualizerState();
}

class VisualizerNotifier extends StateNotifier<VisualizerState> {
  VisualizerNotifier() : super(VisualizerState.initial());

  final ImagePicker _picker = ImagePicker();

  /// Picks an image and performs structural validation scanning
  Future<void> importAndValidateImage(ImageSource source) async {
    state = state.copyWith(
      isInitializing: true,
      isValidating: false,
      isValidated: false,
      isValidationFailed: false,
      validationMessage: null,
      originalImageBytes: null,
      workingImageBytes: null,
      processedImageBytes: null,
      undoHistory: [],
      aiRecommendations: [],
      aiError: null,
      error: null,
      savePath: null,
    );

    try {
      final file = await _picker.pickImage(source: source, imageQuality: 92);
      if (file == null) {
        state = state.copyWith(isInitializing: false);
        return;
      }

      final bytes = await file.readAsBytes();
      
      // Enter the "Validation Scan" state to show the laser scanning animation
      state = state.copyWith(
        isInitializing: false,
        isValidating: true,
        originalImageBytes: bytes,
      );

      // Simulate a high-tech scan delay (2 seconds)
      await Future.delayed(const Duration(seconds: 2));

      // Perform structural validation
      final isValid = await LocalRecolorHelper.validateImageStructure(bytes);

      if (!isValid) {
        state = state.copyWith(
          isValidating: false,
          isValidationFailed: true,
          validationMessage: 'Validation Failed:\nNo house, walls, or building structures detected in this photo.',
        );
      } else {
        // Validation succeeded! Resize to a standard working size for real-time local flood fill
        final workingBytes = await LocalRecolorHelper.resizeToWorkingSize(bytes);
        state = state.copyWith(
          isValidating: false,
          isValidated: true,
          workingImageBytes: workingBytes,
          processedImageBytes: workingBytes,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isInitializing: false,
        isValidating: false,
        isValidationFailed: true,
        validationMessage: 'Error loading photo: ${e.toString()}',
      );
    }
  }

  /// Sets the selected color shade depending on the active slot
  void selectShade(ColorShade shade) {
    if (state.isCombinationMode) {
      if (state.activeShadeSlot == 1) {
        state = state.copyWith(primaryShade: shade);
      } else {
        state = state.copyWith(secondaryShade: shade);
      }
    } else {
      state = state.copyWith(primaryShade: shade, secondaryShade: null);
    }
  }

  /// Toggles multi-color combination mode
  void toggleCombinationMode(bool enabled) {
    ColorShade? second = state.secondaryShade;
    if (enabled && second == null) {
      second = state.primaryShade;
    }
    state = state.copyWith(
      isCombinationMode: enabled,
      secondaryShade: second,
      activeShadeSlot: 1,
    );
  }

  /// Sets whether the user is painting with Primary or Secondary color
  void setActiveSlot(int slot) {
    if (slot == 1 || slot == 2) {
      state = state.copyWith(activeShadeSlot: slot);
    }
  }

  /// Taps on a wall to apply the active color using flood-fill and texture mapping
  Future<void> paintAtPosition({
    required double localX,
    required double localY,
    required double containerWidth,
    required double containerHeight,
  }) async {
    final workingBytes = state.processedImageBytes ?? state.workingImageBytes;
    if (workingBytes == null) return;

    // Get the active paint color
    final ColorShade? activeShade = (state.isCombinationMode && state.activeShadeSlot == 2)
        ? state.secondaryShade
        : state.primaryShade;

    if (activeShade == null) {
      state = state.copyWith(error: 'Please select a color from the catalogue first.');
      return;
    }

    // Convert hex string (e.g. #FFFFFF) to a Flutter Color object
    final Color paintColor = _parseHexColor(activeShade.hex);

    state = state.copyWith(isInitializing: true, error: null);

    try {
      // Decode image dimensions to map local tap coordinates to actual pixel coordinates
      // Since localRecolorHelper already runs on decoded images, we do a quick decode here
      // to calculate aspect ratios
      final imgDimensions = await _getImageDimensions(workingBytes);
      if (imgDimensions == null) {
        throw Exception('Failed to parse working image.');
      }

      final imgWidth = imgDimensions.width;
      final imgHeight = imgDimensions.height;

      // Calculate coordinates mapping including potential letterboxing
      final double containerAspect = containerWidth / containerHeight;
      final double imgAspect = imgWidth / imgHeight;

      double renderedW = containerWidth;
      double renderedH = containerHeight;
      double offsetX = 0;
      double offsetY = 0;

      if (imgAspect > containerAspect) {
        // Image is wider than container: letterboxed top/bottom
        renderedH = containerWidth / imgAspect;
        offsetY = (containerHeight - renderedH) / 2;
      } else {
        // Image is taller than container: letterboxed left/right
        renderedW = containerHeight * imgAspect;
        offsetX = (containerWidth - renderedW) / 2;
      }

      // Check if tap was within the actual rendered image boundaries
      final double relativeX = localX - offsetX;
      final double relativeY = localY - offsetY;

      if (relativeX < 0 || relativeX >= renderedW || relativeY < 0 || relativeY >= renderedH) {
        state = state.copyWith(isInitializing: false);
        return; // Clicked outside the actual photo borders
      }

      // Scale coordinates to match original pixel matrix
      final int pixelX = ((relativeX / renderedW) * imgWidth).round().clamp(0, imgWidth.toInt() - 1);
      final int pixelY = ((relativeY / renderedH) * imgHeight).round().clamp(0, imgHeight.toInt() - 1);

      // Perform local queue-based flood fill recoloring in a background Isolate
      final updatedBytes = await compute(
        LocalRecolorHelper.applyFloodFillRecolorIsolate,
        RecolorParams(
          imageBytes: workingBytes,
          startX: pixelX,
          startY: pixelY,
          targetColor: paintColor,
          tolerance: state.tolerance,
        ),
      );

      // Push history for undo support
      final history = List<Uint8List>.from(state.undoHistory)..add(workingBytes);

      state = state.copyWith(
        isInitializing: false,
        processedImageBytes: updatedBytes,
        undoHistory: history,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isInitializing: false,
        error: 'Failed to paint: ${e.toString()}',
      );
    }
  }

  /// Undoes the last paint stroke
  void undoLastStroke() {
    if (state.undoHistory.isEmpty) return;

    final history = List<Uint8List>.from(state.undoHistory);
    final previousBytes = history.removeLast();

    state = state.copyWith(
      processedImageBytes: previousBytes,
      undoHistory: history,
      error: null,
    );
  }

  /// Updates the paint tolerance/sensitivity threshold
  void updateTolerance(double val) {
    state = state.copyWith(tolerance: val);
  }

  /// Queries the client-side Gemini API for room style & paint shade recommendations
  Future<void> askAiAdvisor() async {
    final workingBytes = state.workingImageBytes;
    if (workingBytes == null) return;

    state = state.copyWith(
      loadingAiSuggestions: true,
      aiRecommendations: [],
      aiError: null,
    );

    try {
      final results = await GeminiAdvisorService.getPaintRecommendations(workingBytes);
      state = state.copyWith(
        loadingAiSuggestions: false,
        aiRecommendations: results,
      );
    } catch (e) {
      state = state.copyWith(
        loadingAiSuggestions: false,
        aiError: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Saves the finalized painted design to the public device gallery
  Future<void> saveToGallery() async {
    final bytes = state.processedImageBytes ?? state.workingImageBytes;
    if (bytes == null) return;

    state = state.copyWith(isSaving: true, savePath: null, error: null);

    try {
      // Check/Request storage and photos permissions
      bool hasPermission = false;
      if (Platform.isAndroid) {
        if (await Permission.photos.request().isGranted) {
          hasPermission = true;
        } else if (await Permission.storage.request().isGranted) {
          hasPermission = true;
        }
      } else {
        hasPermission = await Permission.photos.request().isGranted;
      }

      if (!hasPermission) {
        state = state.copyWith(
          isSaving: false,
          error: 'Write permission was denied. Please grant storage access in Settings to save photos.',
        );
        return;
      }

      String? path;
      if (Platform.isAndroid) {
        final dir = Directory('/storage/emulated/0/Pictures/PaintStore');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        final file = File('${dir.path}/paint_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(bytes);
        path = file.path;
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/paint_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(bytes);
        path = file.path;
      }

      state = state.copyWith(
        isSaving: false,
        savePath: path,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save design: ${e.toString()}',
      );
    }
  }

  /// Resets the page state to import a new image
  void clearImage() {
    state = VisualizerState.initial();
  }

  /// Parses a hex color string into a Flutter Color
  Color _parseHexColor(String hex) {
    try {
      String clean = hex.trim().replaceAll('#', '');
      if (clean.length == 6) {
        clean = 'FF$clean'; // Add opacity channel
      }
      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return Colors.red;
    }
  }

  /// Decodes and extracts image dimensions from raw bytes
  Future<Size?> _getImageDimensions(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return Size(frame.image.width.toDouble(), frame.image.height.toDouble());
    } catch (_) {
      return null;
    }
  }
}
