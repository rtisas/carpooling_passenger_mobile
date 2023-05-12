import 'dart:async';
import 'dart:convert';

import 'package:carpooling_passenger/data/models/helpers/bookingState.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/application/preferences.dart';
import '../../../../../data/models/booking/booking_response.dart';
import '../../../../../domain/usescases/booking/booking_use_case.dart';
import '../../../../../domain/usescases/routes/routes_use_case.dart';

class BookingDetailController extends GetxController {
  final RoutesUseCase _routesUseCase;
  final BookingUseCase _bookingUseCase;

  Rx<List<PointLatLng>>? polylinePoints = Rx([]);
  Rx<Set<Marker>> markersRoute = Rx({});
  Rx<PassengerResoponse?> passenger = Rx(null);

  RxBool isLoading = false.obs;
  final bookingDetailArgument = Get.arguments as BookingResponseComplete;
  Rx<BookingResponseComplete?> bookingComplete = Rx(
      null); // variable que contiene la booking "actualizada" consultada por id

  final Completer<GoogleMapController> controllerMap =
      Completer<GoogleMapController>();

  BookingDetailController(this._routesUseCase, this._bookingUseCase);

  @override
  void onInit() async {
    await getBooking();
    passenger.value = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''));
    setMarkesInParadaStartAndEnd();
    await getWayPointsFromGoogleMaps();
    super.onInit();
  }

  getBooking() async {
    await _bookingUseCase
        .getBookingById(bookingDetailArgument.id.toString())
        .then((value) => value.fold((failure) {
              print('LOG Ocurrió un error BookingById ${failure.message}');
            }, (bookingResponse) {
              if(bookingResponse.state.id.toString() == STATUS_BOOKING.FINALIZADO.value){
                Get.offAllNamed('/home');
              }
              bookingComplete.value = bookingResponse;
            }));
  }

  setMarkesInParadaStartAndEnd() {
    markersRoute.value.add(Marker(
        markerId: MarkerId(bookingDetailArgument.startStation.index.toString()),
        position: LatLng(
            double.parse(bookingDetailArgument.startStation.latitude),
            double.parse(bookingDetailArgument.startStation.longitude)),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: bookingDetailArgument.startStation.nameStation,
        )));
    markersRoute.value.add(Marker(
        markerId: MarkerId(bookingDetailArgument.endStation.index.toString()),
        position: LatLng(
            double.parse(bookingDetailArgument.endStation.latitude),
            double.parse(bookingDetailArgument.endStation.longitude)),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: bookingDetailArgument.endStation.nameStation,
        )));
  }

  getWayPointsFromGoogleMaps() async {
    //TODO: EL 99 ES LA ÚLTIMA ESTACIÓN
    isLoading.value = true;
    List<String> waypoints = [];
    String latlogDestine =
        '${bookingDetailArgument.endStation.latitude},${bookingDetailArgument.endStation.longitude}';
    String latlogOrigen =
        '${bookingDetailArgument.startStation.latitude},${bookingDetailArgument.startStation.longitude}';
    await _routesUseCase
        .getWayPointsFromGoogleMaps(latlogOrigen, latlogDestine, waypoints)
        .then((value) => value.fold((failure) {
              isLoading.value = false;
            }, (responsePolyline) {
              polylinePoints?.value = PolylinePoints().decodePolyline(
                  responsePolyline.routes[0].overviewPolyline.points);
              isLoading.value = false;
              return polylinePoints;
            }));
  }

  void showMessage(String title, String content) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      content,
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
