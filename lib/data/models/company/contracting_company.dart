import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/data/models/helpers/parameter.dart';

class ContractingCompany {
  ContractingCompany({
    required this.updateDate,
    required this.address,
    required this.companyType,
    required this.mobileNumber,
    required this.businessName,
    required this.contractNumber,
    required this.identificationType,
    required this.updater,
    required this.phoneNumber,
    required this.nit,
    required this.companyResponsible,
    required this.id,
    required this.email,
    required this.status,
  });

  DateTime updateDate;
  String address;
  Parameter companyType;
  String mobileNumber;
  String businessName;
  String contractNumber;
  Parameter identificationType;
  OnlyId updater;
  String phoneNumber;
  String nit;
  dynamic companyResponsible;
  int id;
  String email;
  bool status;

  factory ContractingCompany.fromJson(Map<String, dynamic> json) =>
      ContractingCompany(
        updateDate: DateTime.parse(json["updateDate"]),
        address: json["address"],
        companyType: Parameter.fromJson(json["companyType"]),
        mobileNumber: json["mobileNumber"],
        businessName: json["businessName"],
        contractNumber: json["contractNumber"],
        identificationType: Parameter.fromJson(json["identificationType"]),
        updater: OnlyId.fromJson(json["updater"]),
        phoneNumber: json["phoneNumber"],
        nit: json["nit"],
        companyResponsible: json["companyResponsible"] == null
            ? null
            : ContractingCompany.fromJson(json["companyResponsible"]),
        id: json["id"],
        email: json["email"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "updateDate": updateDate.toIso8601String(),
        "address": address,
        "companyType": companyType.toJson(),
        "mobileNumber": mobileNumber,
        "businessName": businessName,
        "contractNumber": contractNumber,
        "identificationType": identificationType.toJson(),
        "updater": updater.toJson(),
        "phoneNumber": phoneNumber,
        "nit": nit,
        "companyResponsible": companyResponsible == null ? null : companyResponsible.toJson(),
        "id": id,
        "email": email,
        "status": status,
      };
}
