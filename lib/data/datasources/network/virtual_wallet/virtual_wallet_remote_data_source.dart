import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exeptions.dart';
import '../../../models/virtual_wallet/history_recharge.dart';
import '../web_service.dart';

abstract class VirtualWalletDataSource {
  //Obtener la billetera virtual del pasajero
  Future<VirtualWalletResponse> getVirtualWalletByPassenger(String idPassenger);
  Future<List<HisotoryRecharge>> getHistoryRecharge(String idPassenger);
}

class VirtualWalletDataSourceImpl implements VirtualWalletDataSource {
  final WebService webService;

  VirtualWalletDataSourceImpl(this.webService);

  @override
  Future<VirtualWalletResponse> getVirtualWalletByPassenger(
      String idPassenger) async {
    try {
      final http = await webService.httpClient();
      final response =
          await http.get('facade/get-virtualwallet/passenger/$idPassenger');
      if (response.statusCode == 200) {
        final VirtualWalletResponse virtualWalletPassenger =
            VirtualWalletResponse.fromJson(response.data);
        return virtualWalletPassenger;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }

  @override
  Future<List<HisotoryRecharge>> getHistoryRecharge(String idPassenger) async {
    try {
      final http = await webService.httpClient();
      final response =
          await http.get('facade/get-recharge/passenger/$idPassenger');
      if (response.statusCode == 200) {
        final List<dynamic> listaData = response.data;
        final List<HisotoryRecharge> listHistoryRecharge = [];

        for (var recharge in listaData) {
          listHistoryRecharge.add(HisotoryRecharge.fromJson(recharge));
        }
        return listHistoryRecharge;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }
}
