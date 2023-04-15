import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/data/models/helpers/parameter.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/data/models/routes/route_response.dart';
import 'package:carpooling_passenger/data/models/routes/station_response.dart';
import 'package:carpooling_passenger/data/models/service_carpooling/service_carpooling.dart';
import 'package:flutter/material.dart';

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
  OnlyId endStation;
  dynamic comments;
  int index;
  int qualifiying;
  dynamic finalizedService;
  dynamic aproxBooking;
  OnlyId route;
  dynamic startService;
  OnlyId passenger;
  dynamic service;
  OnlyId startStation;
  int id;
  String dateBooking;

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        timeBooking: json["timeBooking"],
        endStation: OnlyId.fromJson(json["endStation"]),
        comments: json["comments"],
        index: json["index"],
        qualifiying: json["qualifiying"],
        finalizedService: json["finalizedService"],
        aproxBooking: json["aproxBooking"],
        route: OnlyId.fromJson(json["route"]),
        startService: json["startService"],
        passenger: OnlyId.fromJson(json["passenger"]),
        service: json["service"],
        startStation: OnlyId.fromJson(json["startStation"]),
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

class BookingResponseComplete {
  BookingResponseComplete({
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
    required this.state,
    required this.dateBooking,
    this.color
  });
  Color? color;
  String timeBooking;
  StationResponse endStation;
  String? comments;
  int index;
  String? qualifiying;
  dynamic finalizedService;
  String? aproxBooking;
  RouteResponse? route;
  DateTime? startService;
  PassengerResoponse passenger;
  ServiceCarpooling? service;
  StationResponse startStation;
  int id;
  Parameter state;
  String dateBooking;

  factory BookingResponseComplete.fromJson(Map<String, dynamic> json) =>
      BookingResponseComplete(
        timeBooking: json["timeBooking"],
        endStation: StationResponse.fromJson(json["endStation"]),
        comments: json["comments"],
        index: json["index"],
        qualifiying: json["qualifiying"],
        finalizedService: json["finalizedService"],
        aproxBooking: json["aproxBooking"],
        route: RouteResponse.fromJson(json["route"]),
        startService: json["startSerivce"],
        passenger: PassengerResoponse.fromJson(json["passenger"]),
        service: ( json["service"] != null )
            ? ServiceCarpooling?.fromJson(json["service"])
            : json["service"],
        startStation: StationResponse.fromJson(json["startStation"]),
        id: json["id"],
        state: Parameter.fromJson(json["state"]),
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
        "route": route?.toJson(),
        "startService": startService?.toIso8601String(),
        "passenger": passenger.toJson(),
        "service": service?.toJson(),
        "startStation": startStation.toJson(),
        "id": id,
        "state": state.toJson(),
        "dateBooking": dateBooking,
        "color": color,
      };
}
