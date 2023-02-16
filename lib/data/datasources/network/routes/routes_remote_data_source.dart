
import 'package:dio/dio.dart';

import '../../../../core/application/enviroment.dart';
import '../../../../core/errors/exeptions.dart';
import '../../../models/google/direction_service.dart';
import '../../../models/routes/route_response.dart';
import '../../../models/routes/station_response.dart';
import '../web_service.dart';

abstract class RoutesRemoteDataSource {
  //Obtener todas las rutas de la empresa de transporte
  Future<List<RouteResponse>> getRoutesByCompanyResponsible(
      String idCompanyResponsible);
  //Obtener todos las estaciones por la ruta
  Future<List<StationResponse>> getStationsByRoute(String idRoute);

  Future<DirecctionsService> getWayPointsFromGoogleMaps( 
      String origin, String destination, List<String> waypoints);
}

class RoutesRemoteDataSourceImpl implements RoutesRemoteDataSource {
  final WebService webService;

  RoutesRemoteDataSourceImpl(this.webService);

  @override
  Future<List<RouteResponse>> getRoutesByCompanyResponsible(
      String idCompanyResponsible) async {
    try {
      final http = await webService.httpClient();
      final response =
          await http.get('facade/get-company/routes/$idCompanyResponsible');
      if (response.statusCode == 200) {
        final List<dynamic> listaData = response.data;
        final List<RouteResponse> listRoutes = [];

        for (var route in listaData) {
          listRoutes.add(RouteResponse.fromJson(route));
        }
        return listRoutes;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }

  @override
  Future<List<StationResponse>> getStationsByRoute(String idRoute) async {
    try {
      final http = await webService.httpClient();
      final response = await http.get('facade/get-all/stations/${idRoute}');
      if (response.statusCode == 200) {
        final List<dynamic> listaData = response.data;
        final List<StationResponse> listStations = [];

        listaData.forEach((station) {
          listStations.add(StationResponse.fromJson(station));
        });
        return listStations;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }

  @override
  Future<DirecctionsService> getWayPointsFromGoogleMaps(
      String origin, String destination, List<String> waypoints) async {
    try {
      final Dio _dio = Dio();

      final response = await _dio.get(
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=optimize:true|${waypoints.join('|')}&key=${Enviroment.API_KEY}');
      if (response.statusCode == 200) {
        final DirecctionsService direcctionsService = DirecctionsService.fromJson(response.data);

        if(direcctionsService.routes.isEmpty){
          throw NoFound();
        }

        return direcctionsService;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }
}
