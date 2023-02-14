import 'package:carpooling_passenger/data/models/helpers/parameter.dart';

class User {
    User({
        required this.id,
        required this.identificationType,
        required this.identification,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.phoneNumber,
        required this.roleId,
        required this.status,
    });

    int id;
    Parameter identificationType;
    String identification;
    String firstName;
    String lastName;
    String email;
    String phoneNumber;
    Parameter roleId;
    Parameter status;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        identificationType: Parameter.fromJson(json["identificationType"]),
        identification: json["identification"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        roleId: Parameter.fromJson(json["roleId"]),
        status: Parameter.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "identificationType": identificationType.toJson(),
        "identification": identification,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "roleId": roleId.toJson(),
        "status": status.toJson(),
    };
}
