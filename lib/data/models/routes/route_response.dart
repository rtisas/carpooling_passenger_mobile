import 'package:carpooling_passenger/data/models/company/contracting_company.dart';

class RouteResponse {
    RouteResponse({
        required this.availableTime,
        required this.resource,
        required this.companyResponsible,
        required this.id,
        required this.nameRoute,
        required this.availableDays,
    });

    String availableTime;
    String resource;
    Company companyResponsible;
    int id;
    String nameRoute;
    String availableDays;

    factory RouteResponse.fromJson(Map<String, dynamic> json) => RouteResponse(
        availableTime: json["availableTime"],
        resource: json["resource"],
        companyResponsible: Company.fromJson(json["companyResponsible"]),
        id: json["id"],
        nameRoute: json["nameRoute"],
        availableDays: json["availableDays"],
    );

    Map<String, dynamic> toJson() => {
        "availableTime": availableTime,
        "resource": resource,
        "companyResponsible": companyResponsible.toJson(),
        "id": id,
        "nameRoute": nameRoute,
        "availableDays": availableDays,
    };
}