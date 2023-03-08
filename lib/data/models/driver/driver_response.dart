
import 'package:carpooling_passenger/data/models/helpers/parameter.dart';

import '../passenger/passenger_response.dart';

class DriverResponse {
    DriverResponse({
        required this.address,
        required this.serviceLicence,
        required this.categoryLicence,
        required this.licenceExpiration,
        required this.basicData,
        required this.id,
        required this.pushToken,
        required this.status,
    });

    String address;
    Parameter serviceLicence;
    Parameter categoryLicence;
    DateTime licenceExpiration;
    BasicData basicData;
    int id;
    String pushToken;
    bool status;

    factory DriverResponse.fromJson(Map<String, dynamic> json) => DriverResponse  (
        address: json["address"],
        serviceLicence: Parameter.fromJson(json["serviceLicence"]),
        categoryLicence: Parameter.fromJson(json["categoryLicence"]),
        licenceExpiration: DateTime.parse(json["licenceExpiration"]),
        basicData: BasicData.fromJson(json["basicData"]),
        id: json["id"],
        pushToken: json["pushToken"],
        status: json["status"],
    );

//? se elimino el valor unos parametros de compnay
    Map<String, dynamic> toJson() => {
        "address": address,
        "serviceLicence": serviceLicence.toJson(),
        "categoryLicence": categoryLicence.toJson(),
        "licenceExpiration": "${licenceExpiration.year.toString().padLeft(4, '0')}-${licenceExpiration.month.toString().padLeft(2, '0')}-${licenceExpiration.day.toString().padLeft(2, '0')}",
        "basicData": basicData.toJson(),
        "id": id,
        "pushToken": pushToken,
        "status": status,
    };
}