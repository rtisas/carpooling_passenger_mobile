import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controller/home.controller.dart';
import '../components/card_route.dart';

class RoutesAvailablesTab extends StatefulWidget {
  const RoutesAvailablesTab({super.key});

  @override
  State<RoutesAvailablesTab> createState() => _RoutesAvailablesTabState();
}

class _RoutesAvailablesTabState extends State<RoutesAvailablesTab>
    with AutomaticKeepAliveClientMixin<RoutesAvailablesTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ...homeCtrl.listRoutes.value.map((route) => CardRoute(route: route))
        ],
      ),
    );
  }
}
