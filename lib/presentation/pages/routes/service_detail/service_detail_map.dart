import 'package:carpooling_passenger/presentation/pages/routes/controller/service_detail/service_detail.controller.dart';
import 'package:carpooling_passenger/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/styles/size_config.dart';

class ServiceDetailMapScreen extends StatelessWidget {
  const ServiceDetailMapScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final detailServiceCtrl = Get.find<ServiceDetailController>();

    SizeConfig(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio en ejecución'),
      ),
      body: const _MapsRouteComponent(),
      floatingActionButton: Obx(() {
          return FloatingActionButton.extended(
            onPressed: () async {
              detailServiceCtrl.followerVehicle.value = !detailServiceCtrl.followerVehicle.value;
              await detailServiceCtrl.getLocationDriverRealTime();
            },
            label: (detailServiceCtrl.followerVehicle.value)?  const Text('Dejar de seguir') : const Text('Seguir vehículo'),
            icon: (detailServiceCtrl.followerVehicle.value)? const Icon(Icons.bus_alert) :  const Icon(Icons.location_searching_sharp),
          );
        }
      ),
    );
  }
}

class _MapsRouteComponent extends StatelessWidget {
  const _MapsRouteComponent();

  @override
  Widget build(BuildContext context) {
    final detailServiceCtrl = Get.find<ServiceDetailController>();
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.safeBlockSizeVertical(100),
      child: Obx(() {
        return (detailServiceCtrl.isLoading.value)
            ? const LoadingWidget()
            : GoogleMap(
                rotateGesturesEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: detailServiceCtrl.latLen[0],
                    zoom: 12.4746,
                    tilt: 45.0),
                polylines: {
                  if (detailServiceCtrl.polylinePoints != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: detailServiceCtrl.polylinePoints!.value
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
                markers: {
                  if (detailServiceCtrl.postionConductor.value != null)
                    Marker(
                        icon: detailServiceCtrl.busIcon,
                        markerId: const MarkerId("currentLocation"),
                        position: detailServiceCtrl.postionConductor.value!),
                  ...detailServiceCtrl.markersRoute.value
                },
                onMapCreated: (GoogleMapController controller) {
                  detailServiceCtrl.controllerMap.complete(controller);
                },
              );
      }),
    );
  }
}
