import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../data/models/routes/station_response.dart';
import '../../../../../domain/usescases/routes/routes_use_case.dart';

class ServiceDetailController extends GetxController {
  final RoutesUseCase _routesUseCase;

  final Completer<GoogleMapController> controllerMap =
      Completer<GoogleMapController>();

  RxBool isLoading = false.obs;
  Rx<List<StationResponse>> listStations = Rx([]);
  Rx<Set<Marker>> markersRoute = Rx({});
  List<LatLng> latLen = [];
  Rx<List<PointLatLng>>? polylinePoints = Rx([]);
  RxBool showDialogReserve = false.obs; // nos permite saber si quiere agendar
  ServiceDetailController(this._routesUseCase);


  @override
  void onInit() async {
    await getStationsByRoute();
    super.onInit();
  }

  getLocationDriverRealTime(){
    // databaseReference.child('locations').child('user1').onValue.listen((event) {
    //   if (event.snapshot.value != null) {
    //     setState(() {
    //       _user1Location = LatLng(
    //         event.snapshot.value['latitude'],
    //         event.snapshot.value['longitude'],
    //       );
    //     });
    //   }
    // });
  }

  getStationsByRoute() async {
    isLoading.value = true;
    await _routesUseCase
        .getStationsByRoute(Get.arguments.route.id.toString())
        .then((value) => value.fold((failure) {
              isLoading.value = false;
              return null;
            }, (stationsResponse) async {
              listStations.value = stationsResponse;
              listStations.value.sort((a, b) => a.index.compareTo(b.index));

              for (var station in listStations.value) {
                latLen.add(LatLng(double.parse(station.latitude),
                    double.parse(station.longitude)));
                Marker marker = Marker(
                  markerId: MarkerId(station.index.toString()),
                  position: LatLng(double.parse(station.latitude),
                      double.parse(station.longitude)),
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: InfoWindow(
                    title: station.nameStation,
                  ),
                  onTap: () {
                    showDialogReserve.value = true;
                  },
                );
                markersRoute.value.add(marker);
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

    await _routesUseCase
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
