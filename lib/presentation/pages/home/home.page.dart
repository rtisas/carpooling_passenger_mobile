import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages.dart';
import 'package:carpooling_passenger/presentation/pages/home/controller/home.controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Scaffold(
      body: Screen(homeCtrl: homeCtrl),
      bottomNavigationBar: const _ButtomNavigationBar(),
    );
  }
}

class Screen extends StatelessWidget {
  final HomeController homeCtrl;
  const Screen({
    Key? key,
    required this.homeCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeCtrl.tabIndex.value == 0) {
        return const ProfileMenuPage();
      } else if (homeCtrl.tabIndex.value == 1) {
        return const RoutesPage();
      } else {
        return const VirtualWalletPage();
      }
    });
  }
}

class _ButtomNavigationBar extends StatelessWidget {
  const _ButtomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Obx(() => BottomNavigationBar(
          elevation: 0,
          currentIndex: homeCtrl.tabIndex.value,
          onTap: (value) {
            homeCtrl.tabIndex.value = value;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_rounded),
              label: 'Monedero',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.route),
              label: 'Rutas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ));
  }
}
