import 'package:carpooling_passenger/data/models/routes/station_response.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../data/models/booking/booking_response.dart';
import '../../../../../domain/usescases/routes/routes_use_case.dart';

class BookingDetailController extends GetxController {
  final RoutesUseCase _routesUseCase;
  Rx<List<PointLatLng>>? polylinePoints = Rx([]);
  Rx<Set<Marker>> markersRoute = Rx({});

  RxBool isLoading = false.obs;
  final bookingDetail = Get.arguments as BookingResponseComplete;

  @override
  void onInit() async {
    markersRoute.value.add(Marker(
        markerId: MarkerId(bookingDetail.startStation.index.toString()),
        position: LatLng(double.parse(bookingDetail.startStation.latitude),
            double.parse(bookingDetail.startStation.longitude)),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: bookingDetail.startStation.nameStation,
        )));
    markersRoute.value.add(Marker(
        markerId: MarkerId(bookingDetail.endStation.index.toString()),
        position: LatLng(double.parse(bookingDetail.endStation.latitude),
            double.parse(bookingDetail.endStation.longitude)),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: bookingDetail.endStation.nameStation,
        )));

    await getWayPointsFromGoogleMaps();
    super.onInit();
  }

  BookingDetailController(this._routesUseCase);

  getWayPointsFromGoogleMaps() async {
    //TODO: EL 99 ES LA ÚLTIMA ESTACIÓN
    List<String> waypoints = [];
    String latlogDestine =
        '${bookingDetail.endStation.latitude},${bookingDetail.endStation.longitude}';
    String latlogOrigen =
        '${bookingDetail.startStation.latitude},${bookingDetail.startStation.longitude}';
    await _routesUseCase
        .getWayPointsFromGoogleMaps(latlogOrigen, latlogDestine, waypoints)
        .then((value) => value.fold((l) => null, (responsePolyline) {
              polylinePoints?.value = PolylinePoints().decodePolyline(
                  responsePolyline.routes[0].overviewPolyline.points);
              isLoading.value = false;
              return polylinePoints;
            }));
  }
}
