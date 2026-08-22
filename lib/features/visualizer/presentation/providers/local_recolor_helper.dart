import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class LocalRecolorHelper {
  /// Validates if the photo has structural features (like variance in texture, shadows)
  /// typical of rooms, walls, or building facades.
  static Future<bool> validateImageStructure(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return false;

      // A solid white page, plain sky, or screenshot of pure color lacks texture and detail.
      // We sample pixels and compute standard deviation of luminance.
      final random = Random();
      const sampleCount = 120;
      double sum = 0;
      final List<double> luminanceValues = [];

      for (int i = 0; i < sampleCount; i++) {
        final x = random.nextInt(image.width);
        final y = random.nextInt(image.height);
        final pixel = image.getPixel(x, y);

        // Get RGB channels from pixel (values are normally 0..255)
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();

        // Calculate relative luminance
        final lum = 0.299 * r + 0.587 * g + 0.114 * b;
        sum += lum;
        luminanceValues.add(lum);
      }

      final mean = sum / sampleCount;
      double varianceSum = 0;
      for (final val in luminanceValues) {
        varianceSum += (val - mean) * (val - mean);
      }
      final stdDev = sqrt(varianceSum / sampleCount);

      // Plain solid color sheets, screen captures, or empty documents typically have a standard deviation < 12.
      // Real houses, wall surfaces, and rooms with natural shadows, angles, and textures typically exceed 20.
      return stdDev >= 12.0;
    } catch (_) {
      return false;
    }
  }

  /// Helper to resize an image if it is too large, to keep local flood-fill operations real-time.
  static Future<Uint8List> resizeToWorkingSize(Uint8List imageBytes, {int maxSide = 700}) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return imageBytes;

      final h = image.height;
      final w = image.width;
      final side = max(h, w);

      if (side <= maxSide) {
        return imageBytes;
      }

      final scale = maxSide / side;
      final newW = (w * scale).round();
      final newH = (h * scale).round();

      final resized = img.copyResize(image, width: newW, height: newH);
      return Uint8List.fromList(img.encodeJpg(resized, quality: 90));
    } catch (_) {
      return imageBytes;
    }
  }

  /// Performs queue-based flood fill starting from (startX, startY) on the image bytes,
  /// blends the target color while keeping the highlights and shadow contours,
  /// and returns the newly colored image bytes.
  static Future<Uint8List> applyFloodFillRecolor({
    required Uint8List imageBytes,
    required int startX,
    required int startY,
    required Color targetColor,
    double tolerance = 38.0,
  }) async {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final w = image.width;
    final h = image.height;

    if (startX < 0 || startX >= w || startY < 0 || startY >= h) {
      return imageBytes;
    }

    final startPixel = image.getPixel(startX, startY);
    final startR = startPixel.r.toDouble();
    final startG = startPixel.g.toDouble();
    final startB = startPixel.b.toDouble();

    final queue = Queue<Point<int>>();
    queue.add(Point(startX, startY));

    final visited = <int>{};
    visited.add(startY * w + startX);

    final targetR = targetColor.r * 255.0;
    final targetG = targetColor.g * 255.0;
    final targetB = targetColor.b * 255.0;

    // Queue-based flood fill
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final cx = current.x;
      final cy = current.y;

      final p = image.getPixel(cx, cy);
      final rOrig = p.r.toDouble();
      final gOrig = p.g.toDouble();
      final bOrig = p.b.toDouble();

      // Original luminance: intensity from 0 to 255
      final lOrig = 0.299 * rOrig + 0.587 * gOrig + 0.114 * bOrig;

      // Blend target color realistically: C_new = targetColor * (L_orig / 128)
      // Preserves all structural details, corners, shadow depth, and lighting.
      final scale = lOrig / 128.0;
      final newR = (targetR * scale).round().clamp(0, 255);
      final newG = (targetG * scale).round().clamp(0, 255);
      final newB = (targetB * scale).round().clamp(0, 255);

      image.setPixelRgb(cx, cy, newR, newG, newB);

      // Check 4-connected neighbors
      final neighbors = [
        Point(cx + 1, cy),
        Point(cx - 1, cy),
        Point(cx, cy + 1),
        Point(cx, cy - 1),
      ];

      for (final n in neighbors) {
        final nx = n.x;
        final ny = n.y;
        if (nx < 0 || nx >= w || ny < 0 || ny >= h) continue;

        final idx = ny * w + nx;
        if (visited.contains(idx)) continue;
        visited.add(idx);

        final np = image.getPixel(nx, ny);
        final nr = np.r.toDouble();
        final ng = np.g.toDouble();
        final nb = np.b.toDouble();

        // Euclidean distance in RGB color space
        final dist = sqrt((nr - startR) * (nr - startR) +
            (ng - startG) * (ng - startG) +
            (nb - startB) * (nb - startB));

        if (dist <= tolerance) {
          queue.add(Point(nx, ny));
        }
      }
    }

    return Uint8List.fromList(img.encodeJpg(image, quality: 90));
  }

  /// Isolate entry point for recolor operations.
  static Future<Uint8List> applyFloodFillRecolorIsolate(RecolorParams params) async {
    return applyFloodFillRecolor(
      imageBytes: params.imageBytes,
      startX: params.startX,
      startY: params.startY,
      targetColor: params.targetColor,
      tolerance: params.tolerance,
    );
  }
}

class RecolorParams {
  final Uint8List imageBytes;
  final int startX;
  final int startY;
  final Color targetColor;
  final double tolerance;

  const RecolorParams({
    required this.imageBytes,
    required this.startX,
    required this.startY,
    required this.targetColor,
    required this.tolerance,
  });
}

