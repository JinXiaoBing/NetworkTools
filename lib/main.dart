import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turbo_network_tools/home/home_view.dart';
import 'package:turbo_network_tools/router/app_pages.dart';
import 'package:turbo_network_tools/utils/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WindowManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home:  HomePage(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}


