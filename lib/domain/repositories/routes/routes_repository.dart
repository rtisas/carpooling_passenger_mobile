import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/google/direction_service.dart';
import '../../../data/models/routes/route_response.dart';
import '../../../data/models/routes/station_response.dart';

abstract class RoutesRepository{
  Future<Either<Failure,List<RouteResponse>>> listRoutesByCompanyResponsible(String idCompanyResponsible);
  Future<Either<Failure,List<StationResponse>>> getStationsByRoute(String idRoute);
  Future<Either<Failure,DirecctionsService>> getWayPointsFromGoogleMaps(String origin, String destination, List<String> waypoints);
}