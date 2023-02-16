
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/data/models/routes/route_response.dart';
import 'package:carpooling_passenger/data/models/routes/station_response.dart';

class BookingResponse {
    BookingResponse({
        required this.timeBooking,
        required this.endStation,
        required this.comments,
        required this.index,
        required this.qualifiying,
        required this.finalizedService,
        required this.aproxBooking,
        required this.route,
        required this.startService,
        required this.passenger,
        required this.service,
        required this.startStation,
        required this.id,
        required this.dateBooking,
    });
  
    String timeBooking;
    StationResponse endStation;
    dynamic comments;
    int index;
    int qualifiying;
    dynamic finalizedService;
    dynamic aproxBooking;
    RouteResponse route;
    dynamic startService;
    PassengerResoponse passenger;
    dynamic service;
    StationResponse startStation;
    int id;
    String dateBooking;

    factory BookingResponse.fromJson(Map<String, dynamic> json) => BookingResponse(
        timeBooking: json["timeBooking"],
        endStation: StationResponse.fromJson(json["endStation"]),
        comments: json["comments"],
        index: json["index"],
        qualifiying: json["qualifiying"],
        finalizedService: json["finalizedService"],
        aproxBooking: json["aproxBooking"],
        route: RouteResponse.fromJson(json["route"]),
        startService: json["startService"],
        passenger: PassengerResoponse.fromJson(json["passenger"]),
        service: json["service"],
        startStation: StationResponse.fromJson(json["startStation"]),
        id: json["id"],
        dateBooking: json["dateBooking"],
    );

    Map<String, dynamic> toJson() => {
        "timeBooking": timeBooking,
        "endStation": endStation.toJson(),
        "comments": comments,
        "index": index,
        "qualifiying": qualifiying,
        "finalizedService": finalizedService,
        "aproxBooking": aproxBooking,
        "route": route.toJson(),
        "startService": startService,
        "passenger": passenger.toJson(),
        "service": service,
        "startStation": startStation.toJson(),
        "id": id,
        "dateBooking": dateBooking,
    };
}