
import 'package:carpooling_passenger/data/models/file_carpooling/file_carpooling.dart';
import 'package:carpooling_passenger/data/models/helpers/only_id.dart';

class UploadFileResponse {
    UploadFileResponse({
        required this.firstName,
        required this.lastName,
        required this.profilePicture,
        required this.updateDate,
        required this.identification,
        required this.phoneNumber,
        required this.roleId,
        required this.identificationType,
        required this.id,
        required this.email,
        required this.status,
        required this.updater,
    });

    String firstName;
    String lastName;
    FileCarpooling profilePicture;
    DateTime updateDate;
    String identification;
    String phoneNumber;
    OnlyId roleId;
    OnlyId identificationType;
    int id;
    String email;
    OnlyId status;
    OnlyId updater;

    factory UploadFileResponse.fromJson(Map<String, dynamic> json) => UploadFileResponse(
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: FileCarpooling.fromJson(json["profilePicture"]),
        updateDate: DateTime.parse(json["updateDate"]),
        identification: json["identification"],
        phoneNumber: json["phoneNumber"],
        roleId: OnlyId.fromJson(json["roleId"]),
        identificationType: OnlyId.fromJson(json["identificationType"]),
        id: json["id"],
        email: json["email"],
        status: OnlyId.fromJson(json["status"]),
        updater: OnlyId.fromJson(json["updater"]),
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "profilePicture": profilePicture.toJson(),
        "updateDate": updateDate.toIso8601String(),
        "identification": identification,
        "phoneNumber": phoneNumber,
        "roleId": roleId.toJson(),
        "identificationType": identificationType.toJson(),
        "id": id,
        "email": email,
        "status": status.toJson(),
        "updater": updater.toJson(),
    };
}
