import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';

/// Rasoi App Entry Point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize AuthController globally
  Get.put(AuthController(), permanent: true);

  runApp(const RasoiApp());
}

/// Rasoi App Widget
class RasoiApp extends StatelessWidget {
  const RasoiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,

      // Routes
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // Unknown route
      unknownRoute: GetPage(
        name: '/404',
        page: () => const Scaffold(body: Center(child: Text('Page not found'))),
      ),

      // Default transition
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
