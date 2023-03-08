import 'package:carpooling_passenger/presentation/pages/routes/tabs/bookings_availables_tab.dart';
import 'package:carpooling_passenger/presentation/pages/routes/tabs/routes_availables_tab.dart';
import 'package:flutter/material.dart';


class RoutesPage extends StatelessWidget {
  const RoutesPage({Key? key}) : super(key: key);

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
            BookingsAvailablesTab()
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
            text: 'Reservas',
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.8);
}
