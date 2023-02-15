
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/google/direction_service.dart';
import '../../../data/models/routes/route_response.dart';
import '../../../data/models/routes/station_response.dart';
import '../../repositories/routes/routes_repository.dart';

class RoutesUseCase {
  final RoutesRepository routesRepository;

  RoutesUseCase(this.routesRepository);

  Future<Either<Failure, List<RouteResponse>>> loginUseCase(String idCompanyResponsible) {
    return routesRepository.listRoutesByCompanyResponsible(idCompanyResponsible);
  }
  Future<Either<Failure, List<StationResponse>>> getStationsByRoute(String idRoute) {
    return routesRepository.getStationsByRoute(idRoute);
  }
  Future<Either<Failure, DirecctionsService>> getWayPointsFromGoogleMaps(String origin, String destination, List<String> waypoints) {
    return routesRepository.getWayPointsFromGoogleMaps(origin, destination, waypoints);
  }
}