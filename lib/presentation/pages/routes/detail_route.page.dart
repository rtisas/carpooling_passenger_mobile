import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/styles/generate_color.dart';
import '../../../data/models/routes/route_response.dart';
import '../../widgets/loading.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/routes.controller.dart';

class DetailRoutePage extends StatelessWidget {
  const DetailRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = Get.arguments as RouteResponse;
    final routesCtrl = Get.find<RoutesController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Ruta - ${route.nameRoute}'),
        elevation: 0,
      ),
      body: Obx(() {
        return Center(
            child: (routesCtrl.isLoading.value)
                ? const LoadingWidget()
                : const _Maps());
      }),
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

class _MapsState extends State<_Maps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final routeCtrl = Get.find<RoutesController>();
    return Obx( () {
      print('LOG valor de polylines ${ routeCtrl.polylinePoints }');
      if (routeCtrl.latLen.isEmpty) return const Text('No hay estaciones');
      return Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: routeCtrl.latLen[0], zoom: 14.4746, tilt: 45.0),
            polylines: {
              
              if (routeCtrl.polylinePoints != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: ColorCustom.randomColor(),
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
          // DetailStationWithReserve(),
        ],
      );
    });
  }
}

class DetailStationWithReserve extends StatefulWidget {
  const DetailStationWithReserve({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailStationWithReserve> createState() =>
      _DetailStationWithReserveState();
}

class _DetailStationWithReserveState extends State<DetailStationWithReserve> {
  @override
  Widget build(BuildContext context) {
    final routeCtrl = Get.find<RoutesController>();

    return Obx(() {
      if (routeCtrl.showDialogReserve.value) {
        showModalBottomSheet<Widget>(
            context: context,
            builder: (c) {
              return Container(
                  child: ListTile(
                title: Text('Hola mundo'),
              ));
            }).then((value) {
          if (value == null) {
            routeCtrl.showDialogReserve.value = false;
          }
        });
        return Container();
      }
      return Container();
    });
  }
}
