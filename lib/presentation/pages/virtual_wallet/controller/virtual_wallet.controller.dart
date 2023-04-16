import 'dart:convert';

import 'package:carpooling_passenger/data/models/virtual_wallet/history_recharge.dart';
import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';
import 'package:carpooling_passenger/domain/usescases/virtual_wallet/virtual_waller_use_casa.dart';
import 'package:get/get.dart';

import '../../../../core/application/preferences.dart';
import '../../../../data/models/passenger/passenger_response.dart';

class VirtualWalletController extends GetxController {
  final VirtualWalletUseCase _virtualWalletUseCase;

  RxBool userContainVirtualWallet = false.obs;
  Rx<VirtualWalletResponse?> virtualWalletPassenger = Rx(null);
  Rx<List<HisotoryRecharge>> historyRecharge = Rx([]);
  late PassengerResoponse passenger;

  VirtualWalletController(this._virtualWalletUseCase);

  @override
  void onInit() async {
    passenger = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: "userPassenger") ?? ''));
    getVirtualWalletByPassenger();
    getHisotoryRecharge();
    super.onInit();
  }

  getVirtualWalletByPassenger() async {
    _virtualWalletUseCase
        .getVirtualWalletByPassenger(passenger.id.toString())
        .then((value) => value.fold((l) {
              print('LOG Ocurrió un error ${l.message}');
              userContainVirtualWallet.value = false;
            }, (responseVirtualWallet) {
              userContainVirtualWallet.value = true;
              virtualWalletPassenger.value = responseVirtualWallet;
            }));
  }

  getHisotoryRecharge() async {
    _virtualWalletUseCase
        .getHistoryRechargePassenger(passenger.id.toString())
        .then((value) => value.fold((errorRespose) {
              print(
                  'LOG Ocurrió un erorr al cargar historyRecharge ${errorRespose}');
            }, (listHistoryRecharge) {
              List<DateTime> fechas = listHistoryRecharge.map((recharge) {
                List<String> partesFecha = recharge.paymentDate.split('-');
                int anio = int.parse(partesFecha[0]);
                int mes = int.parse(partesFecha[1]);
                int dia = int.parse(partesFecha[2]);

                return DateTime(anio, mes, dia);
              }).toList();
              fechas.sort((a, b) => b.compareTo(a));
              historyRecharge.value = fechas.map((fecha) {
                return listHistoryRecharge.firstWhere((element) {
                  List<String> partesFecha = element.paymentDate.split('-');
                  int anio = int.parse(partesFecha[0]);
                  int mes = int.parse(partesFecha[1]);
                  int dia = int.parse(partesFecha[2]);

                  return DateTime(anio, mes, dia) == fecha;
                });
              }).toList();
            }));
  }
}
