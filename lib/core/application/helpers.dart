import 'dart:convert';

import 'package:carpooling_passenger/core/application/preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../data/models/passenger/passenger_response.dart';

class Helpers {
  static Future<bool> verificarAuth() async {
    try {
      final token = await Preferences.storage.read(key: 'token');
      PassengerResoponse passenger = PassengerResoponse.fromJson(jsonDecode(
          await Preferences.storage.read(key: 'userPassenger') ?? ''));

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token ?? '');
      if (decodedToken['exp'] != null && verifyPassenger(passenger)) {
        int expiryTimestamp = decodedToken['exp'];
        if (DateTime.now().millisecondsSinceEpoch ~/ 1000 < expiryTimestamp) {
          return true;
        }
      }
    } catch (e) {
      print('LOG Ocurrió un error al momento de válidar ${1}');
      return false;
    }
    return false;
  }

  static bool verifyPassenger(PassengerResoponse passenger) {
    if (passenger.frDestinyLatitude!.isEmpty ||
        passenger.frDestinyLatitude!.isEmpty ||
        passenger.frOriginLatitude!.isEmpty ||
        passenger.frOriginLongitude!.isEmpty ||
        passenger.frOriginHour!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
