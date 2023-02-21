import 'package:carpooling_passenger/data/datasources/network/profile/profile_remote_data_source.dart';
import 'package:carpooling_passenger/data/datasources/network/web_service.dart';
import 'package:carpooling_passenger/data/respositories/profile/profile_repository_impl.dart';
import 'package:carpooling_passenger/domain/usescases/profile/profile_use_case.dart';
import 'package:carpooling_passenger/presentation/pages/profile/controller/profile.controller.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileUseCase(ProfileRepositoryImpl(ProfileRemoteDataSourceImpl(WebService()))));
    Get.put(ProfileController(Get.find()), permanent: false);
  }

}