import 'dart:convert';

import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';
import 'package:carpooling_passenger/domain/usescases/virtual_wallet/virtual_waller_use_casa.dart';
import 'package:get/get.dart';

import '../../../../core/application/preferences.dart';
import '../../../../data/models/passenger/passenger_response.dart';

class VirtualWalletController extends GetxController {
  final VirtualWalletUseCase _virtualWalletUseCase;

  late VirtualWalletResponse virtualWalletPassenger;
  VirtualWalletController(this._virtualWalletUseCase);

  @override
  void onInit() async {
    getVirtualWalletByPassenger();
    super.onInit();
  }

  getVirtualWalletByPassenger() async {
    PassengerResoponse? passengerResponse = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: "userPassenger") ?? ''));
    _virtualWalletUseCase
        .getVirtualWalletByPassenger(passengerResponse.id.toString())
        .then((value) => value.fold((l) {
              print('LOG Ocurrió un error ${l.message}');
            }, (responseVirtualWallet) {
              virtualWalletPassenger = responseVirtualWallet;
            }));
  }
}
