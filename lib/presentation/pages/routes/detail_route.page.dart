import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:carpooling_passenger/presentation/pages/routes/controller/detail_route.controller.dart';
import 'package:carpooling_passenger/core/styles/size_config.dart';
import 'package:intl/intl.dart';
import '../../../core/styles/generate_color.dart';
import '../../widgets/loading.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/routes.controller.dart';

class DetailRoutePage extends StatelessWidget {
  const DetailRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routesCtrl = Get.find<RoutesController>();
    final detailRouteCtrl = Get.find<DetailRouteController>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Ruta - ${detailRouteCtrl.route.nameRoute}'),
          elevation: 0,
        ),
        body: Obx(() {
          return Center(
              child: (routesCtrl.isLoading.value)
                  ? const LoadingWidget()
                  : const _Maps());
        }));
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
        const _GenerateBooking(),
      ],
    );
  }
}

class _GenerateBooking extends StatelessWidget {
  const _GenerateBooking();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              alignment: Alignment.topLeft,
              child: const Text(
                '¡Reserva tu puesto ahora!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const _FormBooking()
          ],
        ),
      ),
    );
  }
}

class _FormBooking extends StatelessWidget {
  const _FormBooking();

  @override
  Widget build(BuildContext context) {
    final detailRouteCtrl = Get.find<DetailRouteController>();

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estación inicial'),
            Obx(() {
              return DropdownButtonFormField(
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor selecciona una opción';
                    }
                    return null;
                  },
                  value: detailRouteCtrl.idSelectedStartStation.value,
                  items: detailRouteCtrl.stationsDropdown,
                  onChanged: (value) {
                    detailRouteCtrl.findStationsEnd(value.toString());
                    detailRouteCtrl.idSelectedStartStation.value =
                        value.toString();
                  });
            }),
            Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estación final'),
                  // if (detailRouteCtrl.stationsDropdownEnd.isNotEmpty)
                  DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona una opción';
                        }
                        return null;
                      },
                      isExpanded: true,
                      value: detailRouteCtrl.isInvalidDropdown.value
                          ? null
                          : detailRouteCtrl.idSelectedEndStation.value,
                      items: detailRouteCtrl.stationsDropdownEnd,
                      onChanged: (value) {
                        detailRouteCtrl.idSelectedEndStation.value =
                            value.toString();
                      })
                ],
              );
            }),
            TextFormField(
              validator: (value) {
                if (value == null || value.length < 3) {
                  return 'Por favor agrega una fecha';
                }
                return null;
              },
              controller: detailRouteCtrl.dateinput,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: "Selecciona la fecha"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025));
                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  detailRouteCtrl.dateinput.text = formattedDate;
                } else {
                  print("Date is not selected");
                }
              },
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.length < 3) {
                  return 'Por favor agrega una hora';
                }
                return null;
              },
              controller: detailRouteCtrl.timeinput,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.timer),
                  labelText: "Selecciona la hora"),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );
                if (pickedTime != null) {
                  // print(pickedTime.format(context)); //output 10:51 PM
                  DateTime parsedTime = DateFormat.jm()
                      .parse(pickedTime.format(context).toString());
                  // print(parsedTime); //output 1970-01-01 22:53:00.000
                  String formattedTime =
                      DateFormat('HH:mm:ss').format(parsedTime);
                  // print(formattedTime); //output 14:59:00
                  //DateFormat() is from intl package, you can format the time on any pattern you need.
                  detailRouteCtrl.timeinput.text = pickedTime.format(context);
                } else {
                  // print("Time is not selected");
                }
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: MaterialButton(
                height: 50,
                color: const Color.fromARGB(255, 21, 94, 178),
                elevation: 0,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                shape: const StadiumBorder(),
                onPressed: () async {
                  await detailRouteCtrl.createBooking();
                },
                child: const Text(
                  "Reservar puesto",
                ),
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
