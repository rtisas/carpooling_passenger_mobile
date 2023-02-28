import 'dart:async';

import 'package:carpooling_passenger/core/application/enviroment.dart';
import 'package:carpooling_passenger/core/styles/size_config.dart';
import 'package:carpooling_passenger/presentation/pages/auth/controller/frecuent_data.controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';

class FrecuentDataPage extends StatefulWidget {
  const FrecuentDataPage({Key? key}) : super(key: key);

  @override
  _FrecuentDataPage createState() => _FrecuentDataPage();
}

class _FrecuentDataPage extends State<FrecuentDataPage> {
  final TextEditingController _searchTextControllerOrigin =
      TextEditingController();
  final TextEditingController _searchTextControllerDestine =
      TextEditingController();
  TextEditingController timeinput = TextEditingController();
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Enviroment.API_KEY);

  final Completer<GoogleMapController> _controllerOrigin = Completer();
  final Completer<GoogleMapController> _controllerDestine = Completer();
  GlobalKey<FormState> form = GlobalKey<FormState>();

  LatLng _center = LatLng(4.606680, -74.097945);
  Set<Marker> _markers = {};
  int _currentStep = 0;
  bool validateStep1 = false;
  bool validateStep2 = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    //TODO: Obtener la ubicación del usuario
    // _determinePosition().then((position) {
    //   setState(() {
    //     _center = LatLng(position.latitude, position.longitude);
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
  }

  @override
  void dispose() {
    _searchTextControllerOrigin.dispose();
    _searchTextControllerDestine.dispose();
    _places.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frecuentDataCtrl = Get.find<FrecuentDataController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Completa tus datos'),
        centerTitle: true,
      ),
      body: Stepper(
        controlsBuilder: (c, details) {
          return Row(
            children: [
              MaterialButton(
                onPressed: details.onStepContinue,
                child: Text('Continuar'),
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              MaterialButton(
                onPressed: details.onStepCancel,
                color: Color.fromARGB(255, 242, 107, 97),
                child: Text('Cancelar'),
              )
            ],
          );
        },
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep == 2) {
            if (frecuentDataCtrl.frecuentDataPasseger["frDestinyLatitude"] !=
                    null &&
                frecuentDataCtrl
                    .frecuentDataPasseger["frDestinyLatitude"]!.isNotEmpty &&
                frecuentDataCtrl.frecuentDataPasseger["frDestinyLongitude"] !=
                    null &&
                frecuentDataCtrl
                    .frecuentDataPasseger["frDestinyLongitude"]!.isNotEmpty &&
                frecuentDataCtrl.frecuentDataPasseger["frOriginLatitude"] !=
                    null &&
                frecuentDataCtrl
                    .frecuentDataPasseger["frOriginLatitude"]!.isNotEmpty &&
                frecuentDataCtrl.frecuentDataPasseger["frOriginLongitude"] !=
                    null &&
                frecuentDataCtrl
                    .frecuentDataPasseger["frOriginLongitude"]!.isNotEmpty &&
                frecuentDataCtrl.frecuentDataPasseger["frOriginHour"] != null &&
                frecuentDataCtrl
                    .frecuentDataPasseger["frOriginHour"]!.isNotEmpty) {
              await frecuentDataCtrl.updatePassager();
            } else {
              frecuentDataCtrl.showMessage(
                  '¡Falto algo!', 'Verifica los datos ingresados');
            }
          }
          if (_currentStep >= 2) return;
          setState(() {
            _currentStep += 1;
          });
        },
        onStepCancel: () {
          if (_currentStep <= 0) return;
          setState(() {
            _currentStep -= 1;
          });
        },
        steps: [
          Step(
            isActive: _currentStep == 0,
            title: Text('Lugar de origen'),
            content: Form(
              key: form,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  TextFormField(
                      validator: (valor) {
                        if (valor!.length < 3) {
                          return 'No es una dirección válida';
                        }
                        return null;
                      },
                      controller: _searchTextControllerOrigin,
                      onChanged: (valor) async {
                        if (_debounce?.isActive ?? false) {
                          _debounce!.cancel();
                        }
                        _debounce =
                            Timer(const Duration(milliseconds: 800), () async {
                          await _searchPlaces(_searchTextControllerOrigin.text,
                              _controllerOrigin);
                          frecuentDataCtrl.frecuentDataPasseger.addAll({
                            "frOriginLatitude": _center.latitude.toString()
                          });
                          frecuentDataCtrl.frecuentDataPasseger.addAll({
                            "frOriginLongitude": _center.longitude.toString()
                          });
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Lugar de origen (frecuente)',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            await _searchPlaces(
                                _searchTextControllerOrigin.text,
                                _controllerOrigin);
                            frecuentDataCtrl.frecuentDataPasseger.addAll({
                              "frOriginLatitude": _center.latitude.toString()
                            });
                            frecuentDataCtrl.frecuentDataPasseger.addAll({
                              "frOriginLongitude": _center.longitude.toString()
                            });
                          },
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: SizeConfig.blockSizeVertical(20),
                    child: GoogleMap(
                      tiltGesturesEnabled: false,
                      initialCameraPosition:
                          CameraPosition(target: _center, zoom: 8),
                      onMapCreated: (GoogleMapController controller) {
                        _controllerOrigin.complete(controller);
                      },
                      markers: _markers,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Step(
            isActive: _currentStep == 1,
            title: Text('Destino (frecuente)'),
            content: Column(
              children: [
                TextFormField(
                    validator: (valor) {
                      if (valor!.length < 3) {
                        return 'No es una dirección válida';
                      }
                      return null;
                    },
                    controller: _searchTextControllerDestine,
                    onChanged: (valor) {
                      if (_debounce?.isActive ?? false) {
                        _debounce!.cancel();
                      }
                      _debounce =
                          Timer(const Duration(milliseconds: 800), () async {
                        await _searchPlaces(_searchTextControllerDestine.text,
                            _controllerDestine);
                        frecuentDataCtrl.frecuentDataPasseger.addAll(
                            {"frDestinyLatitude": _center.latitude.toString()});
                        frecuentDataCtrl.frecuentDataPasseger.addAll({
                          "frDestinyLongitude": _center.longitude.toString()
                        });
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Lugar de destino (frecuente)',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          await _searchPlaces(_searchTextControllerDestine.text,
                              _controllerDestine);
                          frecuentDataCtrl.frecuentDataPasseger.addAll({
                            "frDestinyLatitude": _center.latitude.toString()
                          });
                          frecuentDataCtrl.frecuentDataPasseger.addAll({
                            "frDestinyLongitude": _center.longitude.toString()
                          });
                        },
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: SizeConfig.blockSizeVertical(20),
                  child: GoogleMap(
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    initialCameraPosition:
                        CameraPosition(target: _center, zoom: 12),
                    onMapCreated: (GoogleMapController controller) {
                      _controllerDestine.complete(controller);
                    },
                    markers: _markers,
                  ),
                ),
              ],
            ),
          ),
          Step(
              isActive: _currentStep == 2,
              title: Text('Hora frecuente de partida'),
              content: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.length < 3) {
                        return 'Por favor agrega una hora';
                      }
                      return null;
                    },
                    controller: timeinput,
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
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        String formattedTime =
                            DateFormat('HH:mm:ss').format(parsedTime);
                        frecuentDataCtrl.frecuentDataPasseger
                            .addAll({'frOriginHour': formattedTime});
                        setState(() {
                          timeinput.text = pickedTime.format(context);
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future<void> _searchPlaces(
    String address,
    Completer<GoogleMapController> controllerParm,
  ) async {
    // Limpiamos los marcadores anteriores.
    _markers.clear();
    // Realizamos la búsqueda de lugares.
    PlacesSearchResponse response = await _places.searchByText(
      address,
      language: 'es',
      region: 'co',
    );
    // Si la respuesta es exitosa, agregamos los marcadores al mapa.
    if (response.isOkay) {
      setState(() {
        _markers = _createMarkers(response.results);
        _center = LatLng(response.results.first.geometry!.location.lat,
            response.results.first.geometry!.location.lng);
      });
      // Movemos la cámara del mapa al primer resultado de la búsqueda.
      final GoogleMapController controller = await controllerParm.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _center, zoom: 15)));
    } else {
      print(response.errorMessage);
    }
  }

  Set<Marker> _createMarkers(List<PlacesSearchResult> places) {
    return places.map((place) {
      return Marker(
        markerId: MarkerId(place.placeId),
        position:
            LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
        infoWindow:
            InfoWindow(title: place.name, snippet: place.formattedAddress),
      );
    }).toSet();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently deniedx, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
