import 'dart:async';

import 'package:flutter/cupertino.dart';
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
    _controller.future.then((value) => value.dispose());
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
          if (routeCtrl.listStations.value.isEmpty) {
            return const Center(child: Text('No hay paradas'));
          }
          return (routeCtrl.latLen.isEmpty)
              ? const Center(
                  child: Text('No hay paradas'),
                )
              : SizedBox(
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
                          color: Colors.blue,
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
    final detailRouteCtrl = Get.find<DetailRouteController>();

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              alignment: Alignment.topLeft,
              child: Text(
                '¡Reserva tu puesto ahora! - \$${detailRouteCtrl.route.price}',
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
            Text('Parada inicial'),
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
                  const Text('Parada final'),
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
                DateTime? pickedDate = await _SelectDateValid(
                    context, _getDayOfWeek, detailRouteCtrl);
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
                List<String> timesEnabled =
                    detailRouteCtrl.route.availableTime.split('-');
                String timeFirstString = timesEnabled[0];
                DateTime parsedTime =
                    DateFormat('h:mm a').parse(timeFirstString);
                DateTime time = DateFormat.jm().parse(timeFirstString);
                int hourFirst = time.hour;
                int minuteFirst = time.minute;

                String timeEndString = timesEnabled[1];
                DateTime parsedTimeEnd =
                    DateFormat('h:mm a').parse(timeEndString);
                DateTime timeEnd = DateFormat.jm().parse(timeEndString);
                int hourEnd = timeEnd.hour;
                int minuteEnd = timeEnd.minute;

                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext builder) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Intervalo de tiempo disponible ${detailRouteCtrl.route.availableTime}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                          height: 200,
                          child: CupertinoDatePicker(
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newdate) {
                              detailRouteCtrl.timeinput.text =
                                  TimeOfDay.fromDateTime(newdate)
                                      .format(context);
                            },
                            use24hFormat: false,
                            minuteInterval: 1,
                            mode: CupertinoDatePickerMode.time,
                            minimumDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                hourFirst,
                                minuteFirst),
                            maximumDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                hourEnd,
                                minuteEnd),
                          ),
                        ),
                      ],
                    );
                  },
                );
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
  }

  Future<DateTime?> _SelectDateValid(
      BuildContext context,
      String Function(int dayOfWeek) _getDayOfWeek,
      DetailRouteController detailRouteCtrl) {
    DateTime initialDate = DateTime.now();
    String initialDayOfWeek = _getDayOfWeek(initialDate.weekday);
    List<String> listDaysEnabled =
        detailRouteCtrl.route.availableDays.split(',');

    while (!listDaysEnabled.contains(initialDayOfWeek)) {
      initialDate = initialDate.add(Duration(days: 1));
      initialDayOfWeek = _getDayOfWeek(initialDate.weekday);
    }
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        final dayOfWeek = _getDayOfWeek(day.weekday);
        List<String> listaDiasSinTildes =
            listDaysEnabled.map((e) => quitarTildes(e).toLowerCase()).toList();
        return listaDiasSinTildes
            .contains(quitarTildes(dayOfWeek).toLowerCase());
      },
    );
  }
}

String quitarTildes(String texto) {
  final Map<String, String> caracteresEspeciales = {
    'á': 'a',
    'é': 'e',
    'í': 'i',
    'ó': 'o',
    'ú': 'u',
  };
  caracteresEspeciales.forEach((caracter, sinTilde) {
    texto = texto.replaceAll(RegExp(caracter), sinTilde);
  });

  return texto;
}

String _getDayOfWeek(int dayOfWeek) {
  switch (dayOfWeek) {
    case DateTime.monday:
      return 'Lunes';
    case DateTime.tuesday:
      return 'Martes';
    case DateTime.wednesday:
      return 'Miercoles';
    case DateTime.thursday:
      return 'Jueves';
    case DateTime.friday:
      return 'Viernes';
    case DateTime.saturday:
      return 'Sábado';
    case DateTime.sunday:
      return 'Domingo';
    default:
      throw ArgumentError('Invalid day of week: $dayOfWeek.');
  }
}
