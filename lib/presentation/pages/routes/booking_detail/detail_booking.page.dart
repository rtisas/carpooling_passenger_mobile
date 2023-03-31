import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/styles/size_config.dart';
import '../../../../data/models/booking/booking_response.dart';
import '../../../../data/models/helpers/statusService.dart';
import '../controller/booking_detail/booking_detail.controller.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailBookingCtrl = Get.find<BookingDetailController>();

    return Scaffold(
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await detailBookingCtrl.getBooking();
          },
          child: CustomScrollView(
            slivers: [
              _AppBarCustom(
                  booking: detailBookingCtrl.bookingComplete.value ??
                      detailBookingCtrl.bookingDetailArgument),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DataBookingInformation(
                            bookingDetail:
                                detailBookingCtrl.bookingComplete.value ??
                                    detailBookingCtrl.bookingDetailArgument),
                        if (detailBookingCtrl.bookingComplete.value?.service != null)
                        _CardServiceInformation(
                            bookingDetail:
                                detailBookingCtrl.bookingComplete.value ??
                                    detailBookingCtrl.bookingDetailArgument),
                      ],
                    ),
                  ),
                ]),
              ),
              const SliverToBoxAdapter(child: _MapsWithRouteAndCurrentPosition())
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        return (detailBookingCtrl.bookingComplete.value?.service?.state.id ==
                STATUS_SERVICE.EN_EJECUCION.value)
            ? const _FloatingButtonService()
            : Container();
      }),
      bottomNavigationBar:
          (detailBookingCtrl.bookingDetailArgument.service != null)
              ? Container(
                  margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.qr_code_2),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Tú código QR de pago'),
                                content: (detailBookingCtrl.passenger.basicData
                                            .profilePicture?.qrUrl !=
                                        null)
                                    ? Image.network(detailBookingCtrl.passenger
                                        .basicData.profilePicture!.qrUrl!)
                                    : Container(),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el diálogo
                                    },
                                    child: Text('Aceptar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el diálogo
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                ],
                              ));
                    },
                    label: const Text(
                      'Realizar pago',
                      style: TextStyle(fontSize: 20, letterSpacing: 2),
                    ),
                  ))
              : null,
    );
  }
}

class _AppBarCustom extends StatelessWidget {
  const _AppBarCustom({
    super.key,
    required this.booking,
  });
  final BookingResponseComplete booking;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      floating: true,
      pinned: true,
      expandedHeight: 160.0,
      flexibleSpace: FlexibleSpaceBar(
        background: const Opacity(
            opacity: 0.7,
            child: Image(
                image: NetworkImage(
                    'https://ecomovilidad.net/wp-content/uploads/2012/02/1312378452_0.jpg'),
                fit: BoxFit.cover)),
        titlePadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * 0.12),
        title: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Tu reserva",
                  style: TextStyle(letterSpacing: 1),
                  softWrap: true,
                ),
                Flexible(
                  child: Chip(
                    backgroundColor: booking.color,
                    elevation: 0,
                    side: BorderSide.none,
                    label: Text(
                      "${booking.state.parameterValue}",
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w800),
                      softWrap: true,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class _DataBookingInformation extends StatelessWidget {
  const _DataBookingInformation({
    required this.bookingDetail,
  });

  final BookingResponseComplete bookingDetail;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos de reserva',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Divider(),
            Row(children: [
              const Text('Ruta: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Text('${bookingDetail.route?.nameRoute}')
            ]),
            Row(children: [
              const Text('Hora estiamda bus: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Text(bookingDetail.aproxBooking ?? 'No definida')
            ]),
            Row(children: [
              const Text('Parada de inicio: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Expanded(
                  child: Text(
                '${bookingDetail.startStation.nameStation} - ${bookingDetail.startStation.address}',
                softWrap: true,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ))
            ]),
            Row(children: [
              const Text('Parada de final: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Expanded(
                  child: Text(
                '${bookingDetail.endStation.nameStation} - ${bookingDetail.endStation.address}',
                softWrap: true,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ))
            ])
          ],
        ),
      ),
    );
  }
}

class _CardServiceInformation extends StatelessWidget {
  const _CardServiceInformation({
    super.key,
    required this.bookingDetail,
  });

  final BookingResponseComplete bookingDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos de servicio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(children: [
              const Text('Conductor ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Text(
                  '${bookingDetail.service?.driver?.basicData.firstName} ${bookingDetail.service?.driver?.basicData.lastName}')
            ]),
            Row(children: [
              const Text('Vehículo ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Text(
                  '${bookingDetail.service?.vehicle?.plate} ${bookingDetail.service?.vehicle?.vehicleClass.parameterValue}')
            ]),
          ],
        ),
      ),
    );
  }
}

class _MapsWithRouteAndCurrentPosition extends StatelessWidget {
  const _MapsWithRouteAndCurrentPosition();

  @override
  Widget build(BuildContext context) {
    final detailBookingCtrl = Get.find<BookingDetailController>();
    SizeConfig(context);

    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(15),
            alignment: Alignment.topLeft,
            child: const Text(
              'Revisa las paradas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: SizeConfig.safeBlockSizeVertical(30),
          width: double.infinity,
          child: Obx(() {
            return (detailBookingCtrl.isLoading.value)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    rotateGesturesEnabled: false,
                    mapType: MapType.normal,
                    markers: detailBookingCtrl.markersRoute.value,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            double.parse(detailBookingCtrl.bookingComplete.value
                                    ?.startStation.latitude ??
                                detailBookingCtrl.bookingDetailArgument
                                    .startStation.latitude),
                            double.parse(detailBookingCtrl.bookingComplete.value
                                    ?.startStation.longitude ??
                                detailBookingCtrl.bookingDetailArgument
                                    .startStation.longitude)),
                        zoom: 11.4746,
                        tilt: 45.0),
                    polylines: {
                      Polyline(
                          polylineId: const PolylineId('overview_polyline1'),
                          color: Colors.red,
                          width: 5,
                          points: detailBookingCtrl.polylinePoints!.value
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList()),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      detailBookingCtrl.controllerMap.complete(controller);
                    },
                  );
          }),
        )
      ],
    );
  }
}

class _FloatingButtonService extends StatelessWidget {
  const _FloatingButtonService();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('detail_service',
              arguments: Get.arguments as BookingResponseComplete);
        },
        label: const Text('Ver servicio'));
  }
}
