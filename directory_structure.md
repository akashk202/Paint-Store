# Directory Structure

```
Folder PATH listing
Volume serial number is 4EA6-2D3B
C:.
│   .firebaserc
│   .flutter-plugins
│   .gitignore
│   .metadata
│   analysis_options.yaml
│   database.rules.json
│   firebase.json
│   firepit-log.txt
│   fix_history.sh
│   pubspec.lock
│   pubspec.yaml
│   README.md
│   TESTING.md
│   
├───.github
│   └───workflows
│           backend-docker.yml
│           flutter-ci.yml
│           ios-build.yml
│
├───android
│   │   .gitignore
│   │   build.gradle.kts
│   │   gradle.properties
│   │   settings.gradle.kts
│   │   
│   ├───app
│   │   │   build.gradle.kts
│   │   │   google-services.json
│   │   │
│   │   └───src
│   │       ├───debug
│   │       │       AndroidManifest.xml
│   │       │
│   │       ├───main
│   │       │   │   AndroidManifest.xml
│   │       │   │
│   │       │   ├───java
│   │       │   │   └───com
│   │       │   │       └───example
│   │       │   │           └───c_h_p
│   │       │   │                   MainActivity.java
│   │       │   │
│   │       │   └───res
│   │       │       ├───drawable
│   │       │       │       launch_background.xml
│   │       │       │
│   │       │       ├───drawable-v21
│   │       │       │       launch_background.xml
│   │       │       │
│   │       │       ├───mipmap-hdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-mdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-xhdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-xxhdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-xxxhdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───values
│   │       │       │       styles.xml
│   │       │       │
│   │       │       └───values-night
│   │       │               styles.xml
│   │       │
│   │       └───profile
│   │               AndroidManifest.xml
│   │
│   └───gradle
│       └───wrapper
│               gradle-wrapper.properties
│
├───assets
│   │   Ace.jpg
│   │   Apex.jpg
│   │   asian.jpg
│   │   calc.webp
│   │   color2.jpeg
│   │   color3.jpeg
│   │   delivery1.png
│   │   delivery2.png
│   │   delivery3.png
│   │   google.png
│   │   image_b83903.png
│   │   image_b8a96a.jpg
│   │   image_b8aca7.jpg
│   │   image_b8b0ca.jpg
│   │   image_b8b149.png
│   │   image_c505f5.png
│   │   image_c55c29.png
│   │   indigo.jpg
│   │   logo.jpeg
│   │   onboard1.jpeg
│   │   onboard2.jpeg
│   │   onboard3.jpeg
│   │   pack_size.jpeg
│   │   painter.jpg
│   │   ultima.jpg
│   │
│   └───icon
│           app_icon.png
│
├───docs
│       nginx-visualizer-https.conf
│       nginx-visualizer.conf
│       systemd-visualizer.service
│
├───functions
│       .eslintrc.js
│       .gitignore
│       index.js
│       package.json
│
├───integration_test
│   │   app_auth_env_test.dart
│   │   app_test.dart
│   │   json_to_markdown.dart
│   │   login_flow_test.dart
│   │   personal_info_flow_test.dart
│   │   product_card_test.dart
│   │   README.md
│   │   register_flow_test.dart
│   │   report.json
│   │   report.md
│   │   report.txt
│   │   run_integration_tests.sh
│   │   run_tests_with_reports.sh
│   │   smoke_navigation_test.dart
│   │   TESTING_GUIDE.md
│   │
│   └───reports
│       └───20251201_113112
│               report.json
│
├───ios
│   │   .gitignore
│   │
│   ├───Flutter
│   │       AppFrameworkInfo.plist
│   │       Debug.xcconfig
│   │       Release.xcconfig
│   │
│   ├───Runner
│   │   │   AppDelegate.swift
│   │   │   Info.plist
│   │   │   Runner-Bridging-Header.h
│   │   │
│   │   ├───Assets.xcassets
│   │   │   ├───AppIcon.appiconset
│   │   │   │       Contents.json
│   │   │   │       Icon-App-1024x1024@1x.png
│   │   │   │       Icon-App-20x20@1x.png
│   │   │   │       Icon-App-20x20@2x.png
│   │   │   │       Icon-App-20x20@3x.png
│   │   │   │       Icon-App-29x29@1x.png
│   │   │   │       Icon-App-29x29@2x.png
│   │   │   │       Icon-App-29x29@3x.png
│   │   │   │       Icon-App-40x40@1x.png
│   │   │   │       Icon-App-40x40@2x.png
│   │   │   │       Icon-App-40x40@3x.png
│   │   │   │       Icon-App-50x50@1x.png
│   │   │   │       Icon-App-50x50@2x.png
│   │   │   │       Icon-App-57x57@1x.png
│   │   │   │       Icon-App-57x57@2x.png
│   │   │   │       Icon-App-60x60@2x.png
│   │   │   │       Icon-App-60x60@3x.png
│   │   │   │       Icon-App-72x72@1x.png
│   │   │   │       Icon-App-72x72@2x.png
│   │   │   │       Icon-App-76x76@1x.png
│   │   │   │       Icon-App-76x76@2x.png
│   │   │   │       Icon-App-83.5x83.5@2x.png
│   │   │   │
│   │   │   └───LaunchImage.imageset
│   │   │           Contents.json
│   │   │           LaunchImage.png
│   │   │           LaunchImage@2x.png
│   │   │           LaunchImage@3x.png
│   │   │           README.md
│   │   │
│   │   └───Base.lproj
│   │           LaunchScreen.storyboard
│   │           Main.storyboard
│   │
│   ├───Runner.xcodeproj
│   │   │   project.pbxproj
│   │   │
│   │   ├───project.xcworkspace
│   │   │   │   contents.xcworkspacedata
│   │   │   │
│   │   │   └───xcshareddata
│   │   │           IDEWorkspaceChecks.plist
│   │   │           WorkspaceSettings.xcsettings
│   │   │
│   │   └───xcshareddata
│   │       └───xcschemes
│   │               Runner.xcscheme
│   │
│   ├───Runner.xcworkspace
│   │   │   contents.xcworkspacedata
│   │   │
│   │   └───xcshareddata
│   │           IDEWorkspaceChecks.plist
│   │           WorkspaceSettings.xcsettings
│   │
│   └───RunnerTests
│           RunnerTests.swift
│
├───lib
│   │   firebase_options.dart
│   │   injection_container.dart
│   │   main.dart
│   │   test_helpers.dart
│   │
│   ├───admin
│   │       add_product_page.dart
│   │       admin_dashboard_page.dart
│   │       all_users_page.dart
│   │       manager_requests_page.dart
│   │
│   ├───app
│   ├───auth
│   │       login_page.dart
│   │       personal_info_page.dart
│   │       register_page.dart
│   │
│   ├───core
│   │   ├───error
│   │   │       exceptions.dart
│   │   │       failures.dart
│   │   │
│   │   ├───network
│   │   │       api_interceptor.dart
│   │   │       dio_client.dart
│   │   │
│   │   ├───usecases
│   │   │       usecase.dart
│   │   │
│   │   └───utils
│   │           constants.dart
│   │
│   ├───data
│   │   └───repositories
│   │           cart_repository.dart
│   │           home_repository.dart
│   │           notifications_repository.dart
│   │           orders_repository.dart
│   │           painters_repository.dart
│   │           product_repository.dart
│   │           recommendation_repository.dart
│   │           report_repository.dart
│   │           stock_repository.dart
│   │           user_repository.dart
│   │
│   ├───features
│   │   ├───auth
│   │   │   ├───data
│   │   │   │   ├───datasources
│   │   │   │   │       auth_remote_data_source.dart
│   │   │   │   │
│   │   │   │   ├───models
│   │   │   │   │       user_model.dart
│   │   │   │   │
│   │   │   │   └───repositories
│   │   │   │           auth_repository_impl.dart
│   │   │   │
│   │   │   ├───domain
│   │   │   │   ├───entities
│   │   │   │   │       user_entity.dart
│   │   │   │   │
│   │   │   │   ├───repositories
│   │   │   │   │       auth_repository.dart
│   │   │   │   │
│   │   │   │   └───usecases
│   │   │   │           google_sign_in_usecase.dart
│   │   │   │           login_usecase.dart
│   │   │   │           logout_usecase.dart
│   │   │   │           register_usecase.dart
│   │   │   │           reset_password_usecase.dart
│   │   │   │
│   │   │   └───presentation
│   │   │       ├───bloc
│   │   │       │       auth_bloc.dart
│   │   │       │       auth_event.dart
│   │   │       │       auth_state.dart
│   │   │       │
│   │   │       ├───screens
│   │   │       │       register_screen.dart
│   │   │       │
│   │   │       └───widgets
│   │   │               auth_text_field.dart
│   │   │
│   │   ├───cart
│   │   │   └───bloc
│   │   │           cart_bloc.dart
│   │   │
│   │   ├───checkout
│   │   │   └───bloc
│   │   │           checkout_bloc.dart
│   │   │
│   │   ├───explore
│   │   │   └───bloc
│   │   │           explore_bloc.dart
│   │   │
│   │   ├───home
│   │   │   │   home_coordinator.dart
│   │   │   │
│   │   │   └───bloc
│   │   │           home_bloc.dart
│   │   │
│   │   ├───notifications
│   │   │   └───bloc
│   │   │           notifications_bloc.dart
│   │   │
│   │   ├───painters
│   │   │   └───bloc
│   │   │           painters_bloc.dart
│   │   │
│   │   ├───payment
│   │   │   └───bloc
│   │   │           payment_bloc.dart
│   │   │
│   │   ├───products
│   │   │   ├───data
│   │   │   │   ├───datasources
│   │   │   │   │       product_remote_data_source.dart
│   │   │   │   │
│   │   │   │   ├───models
│   │   │   │   │       product_model.dart
│   │   │   │   │
│   │   │   │   └───repositories
│   │   │   │           product_repository_impl.dart
│   │   │   │
│   │   │   ├───domain
│   │   │   │   ├───entities
│   │   │   │   │       product_entity.dart
│   │   │   │   │
│   │   │   │   ├───repositories
│   │   │   │   │       product_repository.dart
│   │   │   │   │
│   │   │   │   └───usecases
│   │   │   │           get_all_products_usecase.dart
│   │   │   │           search_products_usecase.dart
│   │   │   │
│   │   │   └───presentation
│   │   │       ├───bloc
│   │   │       │       product_bloc.dart
│   │   │       │       product_event.dart
│   │   │       │       product_state.dart
│   │   │       │
│   │   │       ├───screens
│   │   │       │       explore_products_screen.dart
│   │   │       │
│   │   │       └───widgets
│   │   │               product_card.dart
│   │   │
│   │   ├───report
│   │   │   └───bloc
│   │   │           report_bloc.dart
│   │   │
│   │   ├───stock
│   │   │   └───bloc
│   │   │           stock_bloc.dart
│   │   │
│   │   ├───user
│   │   │   └───bloc
│   │   │           user_bloc.dart
│   │   │
│   │   └───visualizer
│   │       └───bloc
│   │               visualizer_bloc.dart
│   │
│   ├───manager
│   │       link_shade_product_page.dart
│   │       manager_dashboard_page.dart
│   │       manage_inventory_page.dart
│   │       manage_latest_colors_page.dart
│   │       manage_orders_page.dart
│   │       manage_users_page.dart
│   │
│   ├───model
│   │       painter_model.dart
│   │       product_model.dart
│   │
│   ├───pages
│   │   │   ar_measure_page.dart
│   │   │   color_catalogue_page.dart
│   │   │   manage_color_catalogue_page.dart
│   │   │   painters_management_page.dart
│   │   │   painting_services_page.dart
│   │   │   paint_calculator_page.dart
│   │   │   paint_results_page.dart
│   │   │   view_painters_page.dart
│   │   │   visualizer_page.dart
│   │   │   work_in_progress_page.dart
│   │   │
│   │   └───core
│   │           cart_page.dart
│   │           checkout_form_page.dart
│   │           home_page.dart
│   │           notifications_page.dart
│   │           payment_page.dart
│   │           report_issue_page.dart
│   │           stock_monitoring_page.dart
│   │
│   ├───product
│   │   │   edit_product_page.dart
│   │   │   explore_product.dart
│   │   │   indigo_product_detail_page.dart
│   │   │   latest_colors_page.dart
│   │   │   manage_products_page.dart
│   │   │   product_detail_page.dart
│   │   │   search_results_page.dart
│   │   │
│   │   └───explore
│   │       │   exterior_page.dart
│   │       │   interior_page.dart
│   │       │   other_products_page.dart
│   │       │   product_display_page.dart
│   │       │   waterproofing_page.dart
│   │       │
│   │       ├───asian
│   │       │   ├───exterior
│   │       │   │       ace_page.dart
│   │       │   │       apex_page.dart
│   │       │   │       asian_paints_exterior_page.dart
│   │       │   │       ultima_page.dart
│   │       │   │
│   │       │   ├───interior
│   │       │   │   │   asian_paints_interior_page.dart
│   │       │   │   │   economy.dart
│   │       │   │   │   luxury.dart
│   │       │   │   │   premium.dart
│   │       │   │   │   super_luxury_page.dart
│   │       │   │   │
│   │       │   │   └───textures
│   │       │   │           exterior_textures_page.dart
│   │       │   │           interior_textures_page.dart
│   │       │   │           manage_textures_page.dart
│   │       │   │           textures_page.dart
│   │       │   │           texture_detail_page.dart
│   │       │   │
│   │       │   └───waterproof
│   │       │           asian_paints_waterproofing_page.dart
│   │       │
│   │       └───indigo
│   │           ├───exterior-emulsions
│   │           │       indigo_paints_exterior_page.dart
│   │           │
│   │           ├───interior-emulsions
│   │           │       indigo_paints_interior_page.dart
│   │           │
│   │           └───waterproofing
│   │                   indigo_paints_waterproofing_page.dart
│   │
│   ├───services
│   │       fcm_background.dart
│   │       fcm_service.dart
│   │       notification_service.dart
│   │       recommendation_service.dart
│   │       visualizer_service.dart
│   │
│   └───widgets
│           featured_carousel.dart
│           home_drawer.dart
│           home_sections.dart
│           loading_screen.dart
│           onboarding_screen.dart
│
├───linux
│   │   .gitignore
│   │   CMakeLists.txt
│   │
│   ├───flutter
│   │       CMakeLists.txt
│   │
│   └───runner
│           CMakeLists.txt
│           main.cc
│           my_application.cc
│           my_application.h
│
├───macos
│   │   .gitignore
│   │
│   ├───Flutter
│   │       Flutter-Debug.xcconfig
│   │       Flutter-Release.xcconfig
│   │
│   ├───Runner
│   │   │   AppDelegate.swift
│   │   │   DebugProfile.entitlements
│   │   │   Info.plist
│   │   │   MainFlutterWindow.swift
│   │   │   Release.entitlements
│   │   │
│   │   ├───Assets.xcassets
│   │   │   └───AppIcon.appiconset
│   │   │           app_icon_1024.png
│   │   │           app_icon_128.png
│   │   │           app_icon_16.png
│   │   │           app_icon_256.png
│   │   │           app_icon_32.png
│   │   │           app_icon_512.png
│   │   │           app_icon_64.png
│   │   │           Contents.json
│   │   │
│   │   ├───Base.lproj
│   │   │       MainMenu.xib
│   │   │
│   │   └───Configs
│   │           AppInfo.xcconfig
│   │           Debug.xcconfig
│   │           Release.xcconfig
│   │           Warnings.xcconfig
│   │
│   ├───Runner.xcodeproj
│   │   │   project.pbxproj
│   │   │
│   │   ├───project.xcworkspace
│   │   │   └───xcshareddata
│   │   │           IDEWorkspaceChecks.plist
│   │   │
│   │   └───xcshareddata
│   │       └───xcschemes
│   │               Runner.xcscheme
│   │
│   ├───Runner.xcworkspace
│   │   │   contents.xcworkspacedata
│   │   │
│   │   └───xcshareddata
│   │           IDEWorkspaceChecks.plist
│   │
│   └───RunnerTests
│           RunnerTests.swift
│
├───recommender_service
│       app.py
│       compute.py
│       requirements.txt
│
├───screenshots
│       .gitkeep
│       cart.png
│       home.png
│       manager_dashboard.png
│       product_detail.png
│
├───scripts
│       deploy_pull_latest.sh
│
├───test
│   │   product_card_test.dart
│   │
│   └───features
│       ├───explore
│       │       explore_view_model_test.dart
│       │
│       ├───home
│       │       home_view_model_test.dart
│       │
│       ├───notifications
│       │       notifications_view_model_test.dart
│       │
│       └───user
│               user_view_model_test.dart
│
├───visualizer_backend
│       .env.example
│       docker-compose.yml
│       Dockerfile
│       main.py
│       README.md
│       recolor.py
│       requirements.txt
│       segmentation.py
│       storage.py
│
├───web
│   │   favicon.png
│   │   index.html
│   │   manifest.json
│   │
│   └───icons
│           Icon-192.png
│           Icon-512.png
│           Icon-maskable-192.png
│           Icon-maskable-512.png
│
└───windows
    │   .gitignore
    │   CMakeLists.txt
    │
    ├───flutter
    │       CMakeLists.txt
    │
    └───runner
        │   CMakeLists.txt
        │   flutter_window.cpp
        │   flutter_window.h
        │   main.cpp
        │   resource.h
        │   runner.exe.manifest
        │   Runner.rc
        │   utils.cpp
        │   utils.h
        │   win32_window.cpp
        │   win32_window.h
        │
        └───resources
                app_icon.ico
```
