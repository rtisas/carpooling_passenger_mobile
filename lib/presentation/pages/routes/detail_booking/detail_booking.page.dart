import 'dart:async';
import 'dart:ffi';

import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/booking_detail/booking_detail.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/styles/size_config.dart';

class DetailBookingPage extends StatelessWidget {
  const DetailBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingDetail = Get.arguments as BookingResponseComplete;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _AppBarCustom(booking: bookingDetail),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DataBookingInformation(bookingDetail: bookingDetail),
                  if (bookingDetail.service != null)
                    _CardServiceInformation(bookingDetail: bookingDetail),
                  _Maps(booking: bookingDetail)
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.qr_code_2),
            onPressed: () {},
            label: const Text(
              'Realizar pago',
              style: TextStyle(fontSize: 20, letterSpacing: 2),
            ),
          )),
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

class _DataBookingInformation extends StatelessWidget {
  const _DataBookingInformation({
    super.key,
    required this.bookingDetail,
  });

  final BookingResponseComplete bookingDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos de reserva',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Divider(),
            Row(children: [
              const Text('Ruta: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Text('${bookingDetail.route?.nameRoute}')
            ]),
            Row(children: [
              const Text('Hora estiamda bus: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Text('${bookingDetail.service?.route.nameRoute ?? 'No definida'}')
            ]),
            // Image.network('https://carpooling-bucket.s3.amazonaws.com/user/123213123/qr/2dfcd789-9cc4-48eb-b2fc-d2d1571a1807.PNG'),
            Row(children: [
              const Text('Parada de inicio: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Expanded(
                  child: Text(
                '${bookingDetail.startStation.nameStation} - ${bookingDetail.startStation.address}',
                softWrap: true,
                style: TextStyle(overflow: TextOverflow.ellipsis),
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
                style: TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ))
            ])
          ],
        ),
      ),
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
                Text(
                  "Tu reserva",
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle(letterSpacing: 1),
                  softWrap: true,
                ),
                Chip(
                  backgroundColor: booking.color,
                  elevation: 0,
                  side: BorderSide.none,
                  label: Text(
                    "${booking.state.parameterValue}",
                    overflow: TextOverflow.visible,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                    softWrap: true,
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class _Maps extends StatefulWidget {
  const _Maps({
    Key? key,
    required this.booking,
  }) : super(key: key);
  final BookingResponseComplete booking;

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
    final detailBookingCtrl = Get.find<BookingDetailController>();
    print('LOG polylinePoints carga ${ detailBookingCtrl.polylinePoints }');
    SizeConfig(context);
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(15),
            alignment: Alignment.topLeft,
            child: const Text(
              'Revisa las paradas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )), SizedBox(
            height: SizeConfig.safeBlockSizeVertical(30),
            width: double.infinity,
            child: Obx( () {
                return GoogleMap(
                  rotateGesturesEnabled: false,
                  mapType: MapType.normal,
                  markers: detailBookingCtrl.markersRoute.value,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          double.parse(widget.booking.startStation.latitude),
                          double.parse(widget.booking.startStation.longitude)),
                      zoom: 14.4746,
                      tilt: 45.0),
                  polylines: {
                      Polyline(
                        polylineId: const PolylineId('overview_polyline1'),
                        color: Colors.red,
                        width: 5,
                        points: detailBookingCtrl.polylinePoints!.value
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList()
                      ),
                  },
                  // markers: routeCtrl.markersRoute.value,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              }
            ),
          )
      ],
    );
  }
}
