//Actualizar los datos de un pasajero

import '../helpers/only_id.dart';

class UpdatePassager {
    UpdatePassager({
        required this.identification,
        required this.firstName,
        required this.lastName,
        required this.phoneNumber,
        required this.email,
        required this.status,
        required this.roleId,
        required this.updater,
        required this.updateDate,
        required this.contractingCompany,
        required this.transportCompany,
        required this.frDestinyLatitude,
        required this.frDestinyLongitude,
        required this.frOriginLatitude,
        required this.frOriginLongitude,
        required this.frOriginHour,
        required this.pushToken,
        required this.identificationType
    });

    String identification;
    OnlyId identificationType;
    String firstName;
    String lastName;
    String phoneNumber;
    String? frDestinyLatitude;
    String? frDestinyLongitude;
    String? frOriginLatitude;
    String? frOriginLongitude;
    String? frOriginHour; //TODO pendiente de cambiar esto
    String? pushToken;
    String email;
    OnlyId status;
    OnlyId roleId;
    OnlyId updater;
    DateTime updateDate;
    OnlyId contractingCompany;
    OnlyId transportCompany;

    factory UpdatePassager.fromJson(Map<String, dynamic> json) => UpdatePassager(
        identification: json["identification"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        status: OnlyId.fromJson(json["status"]),
        roleId: OnlyId.fromJson(json["roleId"]),
        updater: OnlyId.fromJson(json["updater"]),
        updateDate: DateTime.parse(json["updateDate"]),
        contractingCompany: OnlyId.fromJson(json["contractingCompany"]),
        transportCompany: OnlyId.fromJson(json["transportCompany"]),
        frDestinyLatitude: json["frDestinyLatitude"],
        frDestinyLongitude: json["frDestinyLongitude"],
        frOriginLatitude: json["frOriginLatitude"],
        frOriginLongitude: json["frOriginLongitude"],
        frOriginHour: json["frOriginHour"],
        pushToken: json["pushToken"],
        identificationType: OnlyId.fromJson(json["identificationType"])
    );

    Map<String, dynamic> toJson() => {
        "identification": identification,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "email": email,
        "status": status.toJson(),
        "roleId": roleId.toJson(),
        "updater": updater.toJson(),
        "updateDate": updateDate.toIso8601String(),
        "contractingCompany": contractingCompany.toJson(),
        "transportCompany": transportCompany.toJson(),
        "frDestinyLatitude": frDestinyLatitude,
        "frDestinyLongitude": frDestinyLongitude,
        "frOriginLatitude": frOriginLatitude,
        "frOriginLongitude": frOriginLongitude,
        "frOriginHour": frOriginHour,
        "pushToken": pushToken,
        "identificationType": identificationType.toJson()
    };
}