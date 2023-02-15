import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/data/models/helpers/parameter.dart';

import '../company/contracting_company.dart';

class PassengerResoponse {
    PassengerResoponse({
        required this.frDestinyLatitude,
        required this.frOriginLatitude,
        required this.contractingCompany,
        required this.frDestinyLongitude,
        required this.basicData,
        required this.id,
        required this.frOriginHour,
        required this.pushToken,
        required this.transportCompany,
        required this.frOriginLongitude,
    });

    String frDestinyLatitude;
    String frOriginLatitude;
    Company contractingCompany;
    String frDestinyLongitude;
    BasicData basicData;
    int id;
    String frOriginHour;
    String pushToken;
    Company transportCompany;
    String frOriginLongitude;

    factory PassengerResoponse.fromJson(Map<String, dynamic> json) => PassengerResoponse(
        frDestinyLatitude: json["frDestinyLatitude"],
        frOriginLatitude: json["frOriginLatitude"],
        contractingCompany: Company.fromJson(json["contractingCompany"]),
        frDestinyLongitude: json["frDestinyLongitude"],
        basicData: BasicData.fromJson(json["basicData"]),
        id: json["id"],
        frOriginHour: json["frOriginHour"],
        pushToken: json["pushToken"],
        transportCompany: Company.fromJson(json["transportCompany"]),
        frOriginLongitude: json["frOriginLongitude"],
    );

    Map<String, dynamic> toJson() => {
        "frDestinyLatitude": frDestinyLatitude,
        "frOriginLatitude": frOriginLatitude,
        "contractingCompany": contractingCompany.toJson(),
        "frDestinyLongitude": frDestinyLongitude,
        "basicData": basicData.toJson(),
        "id": id,
        "frOriginHour": frOriginHour,
        "pushToken": pushToken,
        "transportCompany": transportCompany.toJson(),
        "frOriginLongitude": frOriginLongitude,
    };
}

class BasicData {
    BasicData({
        required this.firstName,
        required this.lastName,
        required this.updateDate,
        required this.identification,
        required this.phoneNumber,
        required this.role,
        required this.identificationType,
        required this.id,
        required this.email,
        required this.status,
        required this.updater,
    });

    String firstName;
    String lastName;
    DateTime updateDate;
    String identification;
    String phoneNumber;
    Parameter role;
    Parameter identificationType;
    int id;
    String email;
    Parameter status;
    OnlyId updater;

    factory BasicData.fromJson(Map<String, dynamic> json) => BasicData(
        firstName: json["firstName"],
        lastName: json["lastName"],
        updateDate: DateTime.parse(json["updateDate"]),
        identification: json["identification"],
        phoneNumber: json["phoneNumber"],
        role: Parameter.fromJson(json["role"]),
        identificationType: Parameter.fromJson(json["identificationType"]),
        id: json["id"],
        email: json["email"],
        status: Parameter.fromJson(json["status"]),
        updater: OnlyId.fromJson(json["updater"]),
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "updateDate": updateDate.toIso8601String(),
        "identification": identification,
        "phoneNumber": phoneNumber,
        "role": role.toJson(),
        "identificationType": identificationType.toJson(),
        "id": id,
        "email": email,
        "status": status.toJson(),
        "updater": updater.toJson(),
    };
}