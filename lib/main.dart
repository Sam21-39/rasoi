import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart'; // Uncomment when Firebase is configured (requires google-services.json)

import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Uncomment when Firebase is configured

  runApp(
    GetMaterialApp(
      title: "Rasoi",
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
    ),
  );
}
