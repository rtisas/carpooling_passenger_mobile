import 'package:carpooling_passenger/core/application/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:carpooling_passenger/core/application/enviroment.dart';
import 'package:carpooling_passenger/core/styles/app_theme.dart';
import 'presentation/exports/binding.dart';
import 'presentation/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool validateAuth = await Helpers.verificarAuth();

  runApp(MyApp(
    validateAuth: validateAuth,
  ));
}

class MyApp extends StatelessWidget {
  final bool validateAuth;
  const MyApp({super.key, required this.validateAuth});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: Duration.zero,
      debugShowCheckedModeBanner: !Enviroment.production,
      initialRoute: validateAuth // validamos si el usuario ya había ingresado anteriormente para salterse el login
          ? '/home'
          : '/login', // hacer lógica para navegar al home
      initialBinding: AuthBinding(),
      theme: AppTheme().getTheme(),
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(
            name: '/home',
            page: () => const HomePage(),
            bindings: [HomeBinding(), VirtualWalletBinding(), BookingBinding()]),
        GetPage(
            name: '/detail-route',
            page: () => const DetailRoutePage(),
            bindings: [RoutesBinding(), DetailRouteBinding()]),
        GetPage(
            name: '/edit-profile',
            page: () => const EditProfilePage(),
            binding: ProfileBinding()),
        GetPage(
            name: '/frecuent_profile',
            page: () => const FrecuentDataPage(),
            binding: FrecuentDataBinding()),
        GetPage(
            name: '/detail_booking',
            page: () => const BookingDetailPage(),
            bindings: [BookingDetailBinding(), RoutesBinding()]),
        GetPage(
            name: '/detail_service',
            page: () => const ServiceDetailMapScreen(),
            ),
      ],
    );
  }
}
