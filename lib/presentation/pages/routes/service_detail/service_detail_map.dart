import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/styles/size_config.dart';
import '../controller/routes.controller.dart';

class ServiceDetailMapScreen extends StatelessWidget {
   
  const ServiceDetailMapScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _Maps()
    );
  }
}

class _Maps extends StatefulWidget {
  const _Maps({
    Key? key,
  }) : super(key: key);

  @override
  State<_Maps> createState() => _MapsState();
}

class _MapsState extends State<_Maps> with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    final routeCtrl = Get.find<RoutesController>();

    if (routeCtrl.latLen.isEmpty) return const Text('No hay estaciones');
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(15),
            alignment: Alignment.topLeft,
            child: const Text(
              'Revisa las paradas',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            )),
        Obx(() {
          return SizedBox(
            height: SizeConfig.safeBlockSizeVertical(30),
            width: double.infinity,
            child: GoogleMap(
              rotateGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: routeCtrl.latLen[0], zoom: 14.4746, tilt: 45.0),
              polylines: {
                if (routeCtrl.polylinePoints != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: routeCtrl.polylinePoints!.value
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
              markers: routeCtrl.markersRoute.value,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          );
        }),
      ],
    );
  }
}