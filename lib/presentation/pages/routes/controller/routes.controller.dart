import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/models/routes/station_response.dart';
import '../../../../domain/usescases/routes/routes_use_case.dart';
import 'dart:io' show Platform;

class RoutesController extends GetxController {
  final RoutesUseCase routesUseCase;

  RxBool isLoading = false.obs;
  Rx<List<StationResponse>> listStations = Rx([]);
  Rx<Set<Marker>> markersRoute = Rx({});
  List<LatLng> latLen = [];
  Rx<List<PointLatLng>>? polylinePoints = Rx([]);

  RoutesController(this.routesUseCase);

  @override
  void onInit() async {
    await getStationsByRoute();
    super.onInit();
  }

  getStationsByRoute() async {
    isLoading.value = true;
    await routesUseCase
        .getStationsByRoute(Get.arguments.id.toString())
        .then((value) => value.fold((failure) {
              isLoading.value = false;
              return null;
            }, (stationsResponse) async {
              isLoading.value = false;
              listStations.value = stationsResponse;
              listStations.value.sort((a, b) => a.index.compareTo(b.index));

              for (var station in listStations.value) {
                latLen.add(LatLng(double.parse(station.latitude),
                    double.parse(station.longitude)));
                await BitmapDescriptor.fromAssetImage(
                        ImageConfiguration.empty,
                        Platform.isIOS
                            ? 'assets/parada_ios.png'
                            : 'assets/parada.png')
                    .then((value) {
                  Marker marker = Marker(
                      markerId: MarkerId(station.index.toString()),
                      position: LatLng(double.parse(station.latitude),
                          double.parse(station.longitude)),
                      icon: value,
                      infoWindow: InfoWindow(
                        title: station.nameStation,
                      ));
                  markersRoute.value.add(marker);
                });
              }
              return await getWayPointsFromGoogleMaps();
            }));
  }

  getWayPointsFromGoogleMaps() async {
    //TODO: EL 99 ES LA ÚLTIMA ESTACIÓN
    StationResponse destine =
        listStations.value.where((element) => element.index == 99).toList()[0];
    String latlogDestine = '${destine.latitude},${destine.longitude}';
    List<String> waypoints =
        latLen.map((e) => '${e.latitude},${e.longitude}').toList();

    await routesUseCase
        .getWayPointsFromGoogleMaps(
            '${latLen[0].latitude},${latLen[0].longitude}',
            latlogDestine,
            waypoints)
        .then((value) => value.fold((l) => null, (responsePolyline) {
              polylinePoints?.value = PolylinePoints().decodePolyline(
                  responsePolyline.routes[0].overviewPolyline.points);
              isLoading.value = false;
              return polylinePoints;
            }));
  }
}
