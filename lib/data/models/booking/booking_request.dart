
import 'package:carpooling_passenger/data/models/helpers/only_id.dart';

class BookingRequest {
    BookingRequest({
        required this.timeBooking,
        required this.endStation,
        required this.index,
        required this.finalizedService,
        required this.route,
        required this.startService,
        required this.passenger,
        required this.service,
        required this.startStation,
        required this.dateBooking,
    });
  
    String timeBooking;
    OnlyId endStation;
    int index;
    dynamic finalizedService;
    OnlyId route;
    dynamic startService;
    OnlyId passenger;
    dynamic service;
    OnlyId startStation;
    String dateBooking;

    factory BookingRequest.fromJson(Map<String, dynamic> json) => BookingRequest(
        timeBooking: json["timeBooking"],
        endStation: OnlyId.fromJson(json["endStation"]),
        index: json["index"],
        finalizedService: json["finalizedService"],
        route: OnlyId.fromJson(json["route"]),
        startService: json["startService"],
        passenger: OnlyId.fromJson(json["passenger"]),
        service: json["service"],
        startStation: OnlyId.fromJson(json["startStation"]),
        dateBooking: json["dateBooking"],
    );

    Map<String, dynamic> toJson() => {
        "timeBooking": timeBooking,
        "endStation": endStation.toJson(),
        "index": index,
        "finalizedService": finalizedService,
        "route": route.toJson(),
        "startService": startService,
        "passenger": passenger.toJson(),
        "service": service,
        "startStation": startStation.toJson(),
        "dateBooking": dateBooking,
    };
}