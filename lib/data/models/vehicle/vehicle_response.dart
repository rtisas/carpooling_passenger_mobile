
import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/data/models/helpers/parameter.dart';

class VehicleReponse {
    VehicleReponse({
        required this.motor,
        required this.serialNumber,
        required this.color,
        required this.passengerQuanitity,
        required this.plate,
        required this.cylinderCapacity,
        required this.updater,
        required this.updaterDate,
        required this.soatNumber,
        required this.soatExpiration,
        required this.controlCardExpedition,
        required this.vehicleClass,
        required this.model,
        required this.id,
        required this.controlCardNumber,
        required this.insuranceCompany,
        required this.brand,
        required this.controlCardExpiration,
        required this.vehicleType,
        required this.technomechanicsExpiration,
    });

    String motor;
    String serialNumber;
    Parameter color;
    int passengerQuanitity;
    String plate;
    int cylinderCapacity;
    OnlyId updater;
    DateTime updaterDate;
    String soatNumber;
    DateTime soatExpiration;
    DateTime controlCardExpedition;
    Parameter vehicleClass;
    String model;
    int id;
    String controlCardNumber;
    Parameter insuranceCompany;
    Parameter brand;
    DateTime controlCardExpiration;
    Parameter vehicleType;
    DateTime technomechanicsExpiration;

    factory VehicleReponse.fromJson(Map<String, dynamic> json) => VehicleReponse(
        motor: json["motor"],
        serialNumber: json["serialNumber"],
        color: Parameter.fromJson(json["color"]),
        passengerQuanitity: json["passengerQuanitity"],
        plate: json["plate"],
        cylinderCapacity: json["cylinderCapacity"],
        updater: OnlyId.fromJson(json["updater"]),
        updaterDate: DateTime.parse(json["updaterDate"]),
        soatNumber: json["soatNumber"],
        soatExpiration: DateTime.parse(json["soatExpiration"]),
        controlCardExpedition: DateTime.parse(json["controlCardExpedition"]),
        vehicleClass: Parameter.fromJson(json["vehicleClass"]),
        model: json["model"],
        id: json["id"],
        controlCardNumber: json["controlCardNumber"],
        insuranceCompany: Parameter.fromJson(json["insuranceCompany"]),
        brand: Parameter.fromJson(json["brand"]),
        controlCardExpiration: DateTime.parse(json["controlCardExpiration"]),
        vehicleType: Parameter.fromJson(json["vehicleType"]),
        technomechanicsExpiration: DateTime.parse(json["technomechanicsExpiration"]),
    );

    Map<String, dynamic> toJson() => {
        "motor": motor,
        "serialNumber": serialNumber,
        "color": color.toJson(),
        "passengerQuanitity": passengerQuanitity,
        "plate": plate,
        "cylinderCapacity": cylinderCapacity,
        "updater": updater.toJson(),
        "updaterDate": updaterDate.toIso8601String(),
        "soatNumber": soatNumber,
        "soatExpiration": soatExpiration.toIso8601String(),
        "controlCardExpedition": controlCardExpedition.toIso8601String(),
        "vehicleClass": vehicleClass.toJson(),
        "model": model,
        "id": id,
        "controlCardNumber": controlCardNumber,
        "insuranceCompany": insuranceCompany.toJson(),
        "brand": brand.toJson(),
        "controlCardExpiration": controlCardExpiration.toIso8601String(),
        "vehicleType": vehicleType.toJson(),
        "technomechanicsExpiration": technomechanicsExpiration.toIso8601String(),
    };
}
