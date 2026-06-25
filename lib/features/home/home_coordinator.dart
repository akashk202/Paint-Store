import 'package:flutter/material.dart';
import 'package:c_h_p/features/painters/presentation/pages/view_painters_page.dart';
import 'package:c_h_p/features/explore/presentation/pages/color_catalogue_page.dart';
import 'package:c_h_p/features/product/presentation/pages/latest_colors_page.dart';
import 'package:c_h_p/features/visualizer/presentation/pages/paint_calculator_page.dart';
import 'package:c_h_p/features/explore/presentation/pages/explore_page.dart';

class HomeCoordinator {
  void onCarouselTap(BuildContext context, Map<String, String> item) {
    final title = item['title'];
    Widget page;
    switch (title) {
      case 'Painting Services':
        page = const ViewPaintersPage();
        break;
      case 'Latest Colors':
        page = const LatestColorsPage();
        break;
      case 'Paint Calculator':
        page = const PaintCalculatorPage();
        break;
      case 'Seasonal Offers':
        // Previously proxied to Color Catalogue as a placeholder
        page = const ColorCataloguePage();
        break;
      default:
        page = const ExploreProductPage();
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
