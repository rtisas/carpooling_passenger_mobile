import 'package:carpooling_passenger/core/styles/size_config.dart';
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
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig(context);
    final homeCtrl = Get.find<HomeController>();
    return RefreshIndicator(
      onRefresh: () async {
        await homeCtrl.getRoutesAvailable();
      },
      child: SingleChildScrollView(
        physics: (homeCtrl.listRoutes.value.length <= 6)? const AlwaysScrollableScrollPhysics() :const BouncingScrollPhysics(),
        child: Obx(() {
          return (homeCtrl.isLoading.value)
              ? Container(
                height: SizeConfig.safeBlockSizeVertical(75),
                child: Center(
                    child: CircularProgressIndicator(),
                  ),
              )
              : Container(
                child: Column(
                    children: [
                      if(homeCtrl.listRoutes.value.isEmpty)
                      Center(child: Text('No hay rutas disponibles al momento')),
                      ...homeCtrl.listRoutes.value
                          .map((route) => CardRoute(route: route))
                    ],
                  ),
              );
        }),
      ),
    );
  }
}
