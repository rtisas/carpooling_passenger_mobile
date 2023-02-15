import 'package:dartz/dartz.dart';

import '../../../core/errors/exeptions.dart';
import '../../../core/errors/failure.dart';
import '../../../domain/repositories/routes/routes_repository.dart';
import '../../datasources/network/routes/routes_remote_data_source.dart';
import '../../models/google/direction_service.dart';
import '../../models/routes/route_response.dart';
import '../../models/routes/station_response.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final RoutesRemoteDataSource _routesRemoteDataSource;

  RoutesRepositoryImpl(this._routesRemoteDataSource);
  @override
  Future<Either<Failure, List<RouteResponse>>> listRoutesByCompanyResponsible(
      String idCompanyResponsible) async {
    try {
      final routesResponse = await _routesRemoteDataSource.getRoutesByCompanyResponsible(idCompanyResponsible);
      return Right(routesResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Ocurrió un error por favor comuníquese con el administrador'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(
          message:
              'No hay rutas disponibles'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }

  @override
  Future<Either<Failure, List<StationResponse>>> getStationsByRoute(String idRoute) async {
     try {
      final stationsResponse = await _routesRemoteDataSource.getStationsByRoute(idRoute);
      return Right(stationsResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Ocurrió un error por favor comuníquese con el administrador'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(
          message:
              'No hay rutas disponibles'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }

  @override
  Future<Either<Failure, DirecctionsService>> getWayPointsFromGoogleMaps(String origin, String destination, List<String> waypoints) async {
    try {
      final directionServiceResponse = await _routesRemoteDataSource.getWayPointsFromGoogleMaps(origin, destination, waypoints);
      return Right(directionServiceResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Ocurrió un error por favor comuníquese con el administrador'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(
          message:
              'No hay rutas disponibles'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }
}
