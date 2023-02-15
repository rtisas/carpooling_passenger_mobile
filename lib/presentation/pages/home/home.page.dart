import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../pages.dart';
import '../routes/routes.page.dart';
import 'package:carpooling_passenger/presentation/pages/home/controller/home.controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Scaffold(
      body: Obx(
        () => Screen(positionTap: homeCtrl.tabIndex.value),
      ),
      bottomNavigationBar: const _ButtomNavigationBar(),
    );
  }
}

class Screen extends StatelessWidget {
  final int positionTap;
  const Screen({
    required this.positionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('LOG valor postionTap ${positionTap}');
    if (positionTap == 0) {
      return const ProfileMenuPage();
    } else if (positionTap == 1) {
      return const RoutesPage();
    } else {
      return const Center(
        child: Text('Monedero'),
      );
    }
  }
}

class _ButtomNavigationBar extends StatelessWidget {
  const _ButtomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: homeCtrl.tabIndex.value,
      onTap: (value) {
        print('LOG cambio de tabIndex ${homeCtrl.tabIndex.value}');
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
    );
  }
}
