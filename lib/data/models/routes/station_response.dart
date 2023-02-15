import 'package:carpooling_passenger/data/models/routes/route_response.dart';

class StationResponse {
    StationResponse({
       required this.address,
       required this.idRoute,
       required this.latitude,
       required this.index,
       required this.id,
       required this.nameStation,
       required this.longitude,
    });

    String address;
    RouteResponse idRoute;
    String latitude;
    int index;
    int id;
    String nameStation;
    String longitude;

    factory StationResponse.fromJson(Map<String, dynamic> json) => StationResponse(
        address: json["address"],
        idRoute: RouteResponse.fromJson(json["idRoute"]),
        latitude: json["latitude"],
        index: json["index"],
        id: json["id"],
        nameStation: json["nameStation"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "idRoute": idRoute.toJson(),
        "latitude": latitude,
        "index": index,
        "id": id,
        "nameStation": nameStation,
        "longitude": longitude,
    };
}
