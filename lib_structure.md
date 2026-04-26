# lib Directory Structure

```
lib/
├── firebase_options.dart
├── main.dart
├── test_helpers.dart
├── admin/
│   ├── add_product_page.dart
│   ├── admin_dashboard_page.dart
│   ├── all_users_page.dart
│   └── manager_requests_page.dart
├── app/
│   └── providers.dart
├── auth/
│   ├── login_page.dart
│   ├── personal_info_page.dart
│   └── register_page.dart
├── data/
│   └── repositories/
│       ├── cart_repository.dart
│       ├── home_repository.dart
│       ├── notifications_repository.dart
│       ├── orders_repository.dart
│       ├── painters_repository.dart
│       ├── product_repository.dart
│       ├── recommendation_repository.dart
│       ├── report_repository.dart
│       ├── stock_repository.dart
│       └── user_repository.dart
├── features/
│   ├── cart/
│   │   └── viewmodel/
│   │       └── cart_view_model.dart
│   ├── checkout/
│   │   └── viewmodel/
│   │       └── checkout_view_model.dart
│   ├── explore/
│   │   └── viewmodel/
│   │       └── explore_view_model.dart
│   ├── home/
│   │   ├── home_coordinator.dart
│   │   └── viewmodel/
│   │       └── home_view_model.dart
│   ├── notifications/
│   │   └── viewmodel/
│   │       └── notifications_view_model.dart
│   ├── painters/
│   │   └── viewmodel/
│   │       └── painters_view_model.dart
│   ├── payment/
│   │   └── viewmodel/
│   │       └── payment_view_model.dart
│   ├── report/
│   │   └── viewmodel/
│   │       └── report_view_model.dart
│   ├── stock/
│   │   └── viewmodel/
│   │       └── stock_view_model.dart
│   ├── user/
│   │   └── viewmodel/
│   │       └── user_view_model.dart
│   └── visualizer/
│       └── viewmodel/
│           └── visualizer_view_model.dart
├── manager/
│   ├── link_shade_product_page.dart
│   ├── manager_dashboard_page.dart
│   ├── manage_inventory_page.dart
│   ├── manage_latest_colors_page.dart
│   ├── manage_orders_page.dart
│   └── manage_users_page.dart
├── model/
│   ├── painter_model.dart
│   └── product_model.dart
├── pages/
│   ├── ar_measure_page.dart
│   ├── color_catalogue_page.dart
│   ├── manage_color_catalogue_page.dart
│   ├── paint_calculator_page.dart
│   ├── paint_results_page.dart
│   ├── painters_management_page.dart
│   ├── painting_services_page.dart
│   ├── view_painters_page.dart
│   ├── visualizer_page.dart
│   ├── work_in_progress_page.dart
│   └── core/
│       ├── cart_page.dart
│       ├── checkout_form_page.dart
│       ├── home_page.dart
│       ├── notifications_page.dart
│       ├── payment_page.dart
│       ├── report_issue_page.dart
│       └── stock_monitoring_page.dart
├── product/
│   ├── edit_product_page.dart
│   ├── explore_product.dart
│   ├── indigo_product_detail_page.dart
│   ├── latest_colors_page.dart
│   ├── manage_products_page.dart
│   ├── product_detail_page.dart
│   ├── search_results_page.dart
│   └── explore/
│       ├── asian/
│       │   ├── exterior/
│       │   │   ├── ace_page.dart
│       │   │   ├── apex_page.dart
│       │   │   ├── asian_paints_exterior_page.dart
│       │   │   └── ultima_page.dart
│       │   ├── interior/
│       │   │   ├── asian_paints_interior_page.dart
│       │   │   ├── economy.dart
│       │   │   ├── luxury.dart
│       │   │   ├── premium.dart
│       │   │   ├── super_luxury_page.dart
│       │   │   └── textures/
│       │   │       ├── exterior_textures_page.dart
│       │   │       ├── interior_textures_page.dart
│       │   │       ├── manage_textures_page.dart
│       │   │       ├── textures_page.dart
│       │   │       └── texture_detail_page.dart
│       │   └── waterproof/
│       │       └── asian_paints_waterproofing_page.dart
│       ├── exterior_page.dart
│       ├── indigo/
│       │   ├── exterior-emulsions/
│       │   │   └── indigo_paints_exterior_page.dart
│       │   ├── interior-emulsions/
│       │   │   └── indigo_paints_interior_page.dart
│       │   └── waterproofing/
│       │       └── indigo_paints_waterproofing_page.dart
│       ├── interior_page.dart
│       ├── other_products_page.dart
│       ├── product_display_page.dart
│       └── waterproofing_page.dart
├── services/
│   ├── fcm_background.dart
│   ├── fcm_service.dart
│   ├── notification_service.dart
│   ├── recommendation_service.dart
│   └── visualizer_service.dart
└── widgets/
    ├── featured_carousel.dart
    ├── home_drawer.dart
    ├── home_sections.dart
    ├── loading_screen.dart
    └── onboarding_screen.dart
```