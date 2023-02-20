import 'package:carpooling_passenger/data/datasources/network/virtual_wallet/virtual_wallet_remote_data_source.dart';
import 'package:carpooling_passenger/data/datasources/network/web_service.dart';
import 'package:carpooling_passenger/data/respositories/virtual_wallet/virtual_wallet_repository_impl.dart';
import 'package:carpooling_passenger/domain/usescases/virtual_wallet/virtual_waller_use_casa.dart';
import 'package:carpooling_passenger/presentation/pages/virtual_wallet/controller/virtual_wallet.controller.dart';
import 'package:get/get.dart';

class VirtualWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VirtualWalletUseCase(VirtualWalletRepositoryImpl(
        VirtualWalletDataSourceImpl(WebService()))));
    Get.put(VirtualWalletController(Get.find()), permanent: false);
  }
}
