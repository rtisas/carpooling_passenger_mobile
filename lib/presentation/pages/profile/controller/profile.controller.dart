import 'dart:convert';


import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/domain/usescases/profile/profile_use_case.dart';
import 'package:carpooling_passenger/presentation/pages/home/controller/home.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/application/preferences.dart';
import '../../../../data/models/helpers/only_id.dart';
import '../../../../data/models/passenger/passenger_update_request.dart';

class ProfileController extends GetxController {
  // GlobalKey<FormState> form = GlobalKey<FormState>();
  Rx<Map<String, dynamic>> userUpdate = Rx({});

  //Seleccionar imágenes
  final _picker = ImagePicker();
  var image = ''.obs; // La imagen seleccionada

  final ProfileUseCase _profileUseCase;
  ProfileController(this._profileUseCase);

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (pickedFile != null) {
      image.value = pickedFile.path;
    }
  }

  Future updatePassager(HomeController homeCtrl) async {
    showLoading();
    PassengerResoponse? passenger = PassengerResoponse.fromJson(
      jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''),
    );
    UpdatePassager updatePassager = UpdatePassager(
        frDestinyLatitude: passenger.frDestinyLatitude,
        frDestinyLongitude: passenger.frDestinyLongitude,
        frOriginLatitude: passenger.frOriginLatitude,
        frOriginLongitude: passenger.frOriginLongitude,
        frOriginHour: passenger.frOriginHour,
        pushToken: passenger.pushToken,

        // Datos a actualizar
        identification: passenger.basicData.identification,
        firstName:
            userUpdate.value['firstName'] ?? passenger.basicData.firstName,
        lastName: userUpdate.value['lastName'] ?? passenger.basicData.lastName,
        phoneNumber:
            userUpdate.value['phoneNumber'] ?? passenger.basicData.phoneNumber,
        email: userUpdate.value['email'] ?? passenger.basicData.email,
        status: OnlyId(id: passenger.basicData.status.id),
        roleId: OnlyId(id: passenger.basicData.role.id),
        updater: OnlyId(id: passenger.basicData.id),
        updateDate: DateTime.now(),
        contractingCompany: OnlyId(id: passenger.contractingCompany.id),
        transportCompany: OnlyId(id: passenger.transportCompany.id),
        identificationType:
            OnlyId(id: passenger.basicData.identificationType.id));

    _profileUseCase
        .updatePassenger(passenger.id.toString(), updatePassager)
        .then((value) => value.fold((errorResponse) async {
              closeDialogLoading();
              print('LOG Ocurrió un error ${errorResponse.message}');
            }, (responseUpdate) async {
              //subir foto
              if (image.value.isNotEmpty) {
                _profileUseCase
                    .uploadFilePictureUser(image.value, passenger.basicData.id.toString())
                    .then((value) => value.fold((errorResponse) {
                          closeDialogLoading();
                          showMessage('Error','Ocurrió un error al momento de cargar la foto');
                        }, (fotoResponse) {
                          closeDialogLoading();
                          homeCtrl.onInit();
                          showMessage('Exito', 'Se ha actualizado el usuario');
                          Get.toNamed('/home');
                        }));
              } else {
                closeDialogLoading();
                homeCtrl.onInit();
                showMessage('Exito', 'Se ha actualizado el usuario');
                Get.toNamed('/home');
              }
              // showMessage('Exito', 'Se ha actualizado el usuario');
              // Get.toNamed('/home');
            }));
  }

  void showLoading() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void showMessage(String title, String content) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      content,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      colorText: Color.fromARGB(255, 0, 0, 0),
      snackPosition: SnackPosition.TOP,
    );
  }

  void closeDialogLoading() {
    Get.back();
  }
}
