import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:carpooling_passenger/core/application/enviroment.dart';
import 'package:carpooling_passenger/core/styles/app_theme.dart';
import 'presentation/exports/binding.dart';
import 'presentation/pages/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: Duration.zero,
      debugShowCheckedModeBanner: !Enviroment.production,
      initialRoute: '/login', // hacer lógica para navegar al home
      initialBinding: AuthBinding(),
      theme: AppTheme().getTheme(),
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(
            name: '/home',
            page: () => const HomePage(),
            bindings: [HomeBinding(), VirtualWalletBinding()]),
        GetPage(
            name: '/detail-route',
            page: () => const DetailRoutePage(),
            bindings: [RoutesBinding(), DetailRouteBinding()]),
        GetPage(name: '/edit-profile', page: () => const EditProfilePage(), binding: ProfileBinding())
      ],
    );
  }
}
