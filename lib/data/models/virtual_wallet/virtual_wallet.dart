import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';

class VirtualWalletResponse {
    VirtualWalletResponse({
        required this.passenger,
        required this.lastRechargeValue,
        required this.id,
        required this.currentValue,
    });

    PassengerResoponse passenger;
    int lastRechargeValue;
    int id;
    int currentValue;

    factory VirtualWalletResponse.fromJson(Map<String, dynamic> json) => VirtualWalletResponse(
        passenger: PassengerResoponse.fromJson(json["passenger"]),
        lastRechargeValue: json["lastRechargeValue"],
        id: json["id"],
        currentValue: json["currentValue"],
    );

    Map<String, dynamic> toJson() => {
        "passenger": passenger.toJson(),
        "lastRechargeValue": lastRechargeValue,
        "id": id,
        "currentValue": currentValue,
    };
}
