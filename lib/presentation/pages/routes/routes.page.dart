import 'package:carpooling_passenger/presentation/pages/routes/tabs/routes_availables_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/routes/route_response.dart';
import '../home/controller/home.controller.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({Key? key, required this.homeCtrl}) : super(key: key);

  final HomeController homeCtrl;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _AppBarTabsRoutes(),
        body: const TabBarView(
          children: [
            Text('Hola a todos'),
            RoutesAvailablesTab(),
            Text('2'),
          ],
        ),
      ),
    );
  }
}

class _AppBarTabsRoutes extends StatelessWidget with PreferredSizeWidget {
  _AppBarTabsRoutes();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text('Rutas'),
      centerTitle: true,
      bottom: const TabBar(
        tabs: [
          Tab(
            text: 'Tu ubicación',
          ),
          Tab(
            text: 'Rutas disponibles',
          ),
          Tab(
            text: 'Servicios',
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.8);
}
