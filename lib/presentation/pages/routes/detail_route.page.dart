import 'package:carpooling_passenger/core/styles/size_config.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/detail_route.controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/styles/generate_color.dart';
import '../../../data/models/routes/route_response.dart';
import '../../widgets/loading.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/routes.controller.dart';

class DetailRoutePage extends StatelessWidget {
  const DetailRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = Get.arguments as RouteResponse;
    final routesCtrl = Get.find<RoutesController>();
    final detailRouteCtrl = Get.find<DetailRouteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ruta - ${route.nameRoute}'),
        elevation: 0,
      ),
      body: Obx(() {
        return Center(
            child: (routesCtrl.isLoading.value)
                ? const LoadingWidget()
                : const _Maps());
      }),
      floatingActionButton:
          _FloatingActionButtonDetailRoute(detailRouteCtrl: detailRouteCtrl),
    );
  }
}

class _FloatingActionButtonDetailRoute extends StatelessWidget {
  const _FloatingActionButtonDetailRoute({
    super.key,
    required this.detailRouteCtrl,
  });

  final DetailRouteController detailRouteCtrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FloatingActionButton.extended(
        onPressed: () {
          detailRouteCtrl.isMapFullScreeen.value =
              !detailRouteCtrl.isMapFullScreeen.value;
        },
        label: Text(
            detailRouteCtrl.isMapFullScreeen.value ? 'Ocultar' : 'Agendar'),
        icon: Icon(detailRouteCtrl.isMapFullScreeen.value
            ? Icons.close
            : Icons.airline_seat_recline_normal_outlined),
      );
    });
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
  late AnimationController _controllerAnimation;
  late Animation<double> _heightAnimation;
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    _controllerAnimation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: SizeConfig.safeBlockSizeVertical(70),
      end: 200,
    ).animate(_controllerAnimation);
    _showAnimation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerAnimation.dispose();
    super.dispose();
  }

  //método que nos permite actualizar el estado de la animación
  void _showAnimation() {
    final detailRouteCtrl = Get.find<DetailRouteController>();
    detailRouteCtrl.isMapFullScreeen.listen(
      (p0) {
        setState(() {
          if (detailRouteCtrl.isMapFullScreeen.value) {
            _controllerAnimation.forward();
          } else {
            _controllerAnimation.reverse();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    final routeCtrl = Get.find<RoutesController>();
    final detailRouteCtrl = Get.find<DetailRouteController>();

    return Obx(() {
      if (routeCtrl.latLen.isEmpty) return const Text('No hay estaciones');
      return Column(
        children: [
          Container(
              margin: const EdgeInsets.all(15),
              alignment: Alignment.topLeft,
              child: const Text(
                'Revisa las paradas',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
          AnimatedBuilder(
              animation: _controllerAnimation,
              builder: (context, child) {
                return Obx(() {
                  return Container(
                    height: _heightAnimation.value,
                    width: double.infinity,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: routeCtrl.latLen[0],
                          zoom: 14.4746,
                          tilt: 45.0),
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
                      onMapCreated: _onMapCreated,
                    ),
                  );
                });
              }),
          if (detailRouteCtrl.isMapFullScreeen.value) const _GenerateBooking(),
        ],
      );
    });
  }
}

class _GenerateBooking extends StatelessWidget {
  const _GenerateBooking();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          alignment: Alignment.topLeft,
          child: const Text(
            '¡Agenda tu puesto ahora!',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        
      ],
    );
  }
}
