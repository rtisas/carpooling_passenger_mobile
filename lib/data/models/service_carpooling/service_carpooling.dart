
import 'package:carpooling_passenger/data/models/driver/driver_response.dart';
import 'package:carpooling_passenger/data/models/helpers/parameter.dart';
import 'package:carpooling_passenger/data/models/routes/route_response.dart';
import 'package:carpooling_passenger/data/models/vehicle/vehicle_response.dart';

class ServiceCarpooling {
    ServiceCarpooling({
        required this.scheduledTime,
        required this.chairsAvailable,
        required this.userIdCompanyResponsible,
        required this.commentsAlert,
        required this.vehicle,
        required this.alerts,
        required this.route,
        required this.driver,
        required this.serviceStartTime,
        required this.nameService,
        required this.servicePrice,
        required this.dateService,
        required this.reservation,
        required this.id,
        required this.state,
        required this.serviceFinishTime,
    });

    String scheduledTime;
    int chairsAvailable;
    UserIdCompanyResponsible userIdCompanyResponsible;
    String? commentsAlert;
    VehicleReponse? vehicle;
    Parameter alerts;
    RouteResponse route;
    DriverResponse? driver;
    String? serviceStartTime;
    String servicePrice;
    DateTime dateService;
    String? nameService;
    int reservation;
    int id;
    Parameter state;
    dynamic serviceFinishTime;

    factory ServiceCarpooling.fromJson(Map<String, dynamic> json) => ServiceCarpooling(
        scheduledTime: json["scheduledTime"],
        chairsAvailable: json["chairsAvailable"],
        userIdCompanyResponsible: UserIdCompanyResponsible.fromJson(json["userIdCompanyResponsible"]),
        commentsAlert: json["commentsAlert"],
        vehicle: VehicleReponse.fromJson(json["vehicle"]),
        alerts: Parameter.fromJson(json["alerts"]),
        route: RouteResponse.fromJson(json["route"]),
        driver: DriverResponse.fromJson(json["driver"]),
        serviceStartTime: json["serviceStartTime"],
        nameService: json["nameService"],
        servicePrice: json["servicePrice"],
        dateService: DateTime.parse(json["dateService"]),
        reservation: json["reservation"],
        id: json["id"],
        state: Parameter.fromJson(json["state"]),
        serviceFinishTime: json["serviceFinishTime"],
    );

    Map<String, dynamic> toJson() => {
        "scheduledTime": scheduledTime,
        "chairsAvailable": chairsAvailable,
        "userIdCompanyResponsible": userIdCompanyResponsible.toJson(),
        "commentsAlert": commentsAlert,
        "vehicle": vehicle?.toJson(),
        "alerts": alerts.toJson(),
        "route": route.toJson(),
        "driver": driver?.toJson(),
        "serviceStartTime": serviceStartTime,
        "servicePrice": servicePrice,
        "nameService": nameService,
        "dateService": dateService.toIso8601String(),
        "reservation": reservation,
        "id": id,
        "state": state.toJson(),
        "serviceFinishTime": serviceFinishTime,
    };
}

class UserIdCompanyResponsible {
    UserIdCompanyResponsible({
        required this.address,
        required this.phoneNumber,
        required this.mobileNumber,
        required this.nit,
        required this.businessName,
        required this.id,
        required this.email,
    });

    String address;
    String phoneNumber;
    String mobileNumber;
    String nit;
    String businessName;
    int id;
    String email;

    factory UserIdCompanyResponsible.fromJson(Map<String, dynamic> json) => UserIdCompanyResponsible(
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        mobileNumber: json["mobileNumber"],
        nit: json["nit"],
        businessName: json["businessName"],
        id: json["id"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "phoneNumber": phoneNumber,
        "mobileNumber": mobileNumber,
        "nit": nit,
        "businessName": businessName,
        "id": id,
        "email": email,
    };
}
