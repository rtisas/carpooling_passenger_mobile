import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/data/models/helpers/parameter.dart';

import '../company/contracting_company.dart';
import '../file_carpooling/file_carpooling.dart';

class PassengerResoponse {
    PassengerResoponse({
        this.frDestinyLatitude,
        this.frOriginLatitude,
        this.frOriginLongitude,
        this.frOriginHour,
        this.pushToken,
        required this.contractingCompany,
        required this.frDestinyLongitude,
        required this.basicData,
        required this.id,
        required this.transportCompany,
    });

    String? frDestinyLatitude;
    String? frOriginLatitude;
    String? pushToken;
    String? frDestinyLongitude;
    String? frOriginLongitude;
    String? frOriginHour;
    Company contractingCompany;
    BasicData basicData;
    int id;
    Company transportCompany;


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
        this.profilePicture
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
    FileCarpooling? profilePicture;

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
        profilePicture: (json["profilePicture"] != null) ?  FileCarpooling?.fromJson(json["profilePicture"]): null,
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
        "profilePicture": profilePicture?.toJson(),
    };
}