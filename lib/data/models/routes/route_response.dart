import 'package:carpooling_passenger/data/models/company/contracting_company.dart';

class RouteResponse {
    RouteResponse({
        required this.availableTime,
        required this.resource,
        required this.companyResponsible,
        required this.id,
        required this.nameRoute,
        required this.availableDays,
        required this.price,
    });

    String availableTime;
    String resource;
    Company companyResponsible;
    int id;
    String nameRoute;
    String availableDays;
    String? price;

    factory RouteResponse.fromJson(Map<String, dynamic> json) => RouteResponse(
        availableTime: json["availableTime"],
        resource: json["resource"],
        companyResponsible: Company.fromJson(json["companyResponsible"]),
        id: json["id"],
        nameRoute: json["nameRoute"],
        price: json["price"],
        availableDays: json["availableDays"],
    );

    Map<String, dynamic> toJson() => {
        "availableTime": availableTime,
        "resource": resource,
        "companyResponsible": companyResponsible.toJson(),
        "id": id,
        "nameRoute": nameRoute,
        "price": price,
        "availableDays": availableDays,
    };
}