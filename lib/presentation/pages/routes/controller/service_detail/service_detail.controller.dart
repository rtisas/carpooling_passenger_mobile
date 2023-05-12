import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  Rx<LatLng?> postionConductor = Rx(null);

  RxBool followerVehicle = false.obs;

  BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;

  ServiceDetailController(this._routesUseCase);
  final refFirebase = FirebaseDatabase.instance.ref();

  @override
  void onInit() async {
    await getStationsByRoute();
    super.onInit();
    getLocationDriverRealTime();
    setMarkerIcon();
  }

  getLocationDriverRealTime() async {
    GoogleMapController googleMapController = await controllerMap.future;

    refFirebase
        .child('services')
        .child(Get.arguments.service.id.toString())
        .onValue
        .listen((event) {
      final dynamic data = event.snapshot.value;
      if (data != null) {
        final latitude = (data['latitude'] ?? 0).toDouble();
        final longitude = (data['longitude'] ?? 0).toDouble();
        postionConductor.value = LatLng(latitude, longitude);
        if (followerVehicle.value) {
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(zoom: 16.5, target: LatLng(latitude, longitude))));
        }
      }
    });
  }

  followDriver() async {
    if (postionConductor.value != null &&
        postionConductor.value?.latitude != null &&
        postionConductor.value?.longitude != null) {
      GoogleMapController googleMapController = await controllerMap.future;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 16.5,
              target: LatLng(postionConductor.value!.latitude,
                  postionConductor.value!.longitude))));
    }
  }

//método que nos permite establecer icono del bus
  setMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      'assets/bus_icon.png',
    ).then((value) => busIcon = value);
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

                await BitmapDescriptor.fromAssetImage(
                        ImageConfiguration.empty, 'assets/parada.png')
                    .then((value) {
                  Marker marker = Marker(
                    markerId: MarkerId(station.index.toString()),
                    position: LatLng(double.parse(station.latitude),
                        double.parse(station.longitude)),
                    icon: value,
                    infoWindow: InfoWindow(
                      title: station.nameStation,
                    ),
                  );
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
