import 'package:carpooling_passenger/presentation/pages/home/controller/home.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/application/preferences.dart';
import '../auth/login.page.dart';

class ProfileMenuPage extends StatelessWidget {
  const ProfileMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 5),
                child: Obx(() {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(
                        homeCtrl.user.value!.basicData.profilePicture?.url ??
                            ''),
                    backgroundColor: Colors.transparent,
                    radius: 80,
                  );
                }),
              ),
              Obx(() {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '${homeCtrl.user.value?.basicData.firstName} ${homeCtrl.user.value?.basicData.lastName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
              OptionProfile(
                title: 'Editar datos personales',
                iconLeading: Icons.person_outline,
                onPress: () {
                  Get.toNamed('/edit-profile');
                },
              ),
              OptionProfile(
                title: 'Historial de servicios',
                iconLeading: Icons.history,
                onPress: () {
                  Get.toNamed('/history-bookings');
                },
              ),
              OptionProfile(
                title: 'Datos frecuentes',
                iconLeading: Icons.find_replace_rounded,
                onPress: () {
                    Get.toNamed('/frecuent_profile');
                },
              ),
              OptionProfile(
                title: 'Cerrar Sesión',
                iconLeading: Icons.exit_to_app_outlined,
                onPress: () async {
                  await Preferences.storage.deleteAll();
                  Get.offAll(() => const LoginPage());
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
           await homeCtrl.getDocumentPassenger();
        },
        label: const Text('Carnet'),
        icon: const Icon(Icons.assignment_ind_rounded),
      ),
    );
  }
}

class OptionProfile extends StatelessWidget {
  final String title;
  final IconData iconLeading;
  final Function onPress;
  const OptionProfile({
    required this.title,
    required this.iconLeading,
    required this.onPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          title: Text(title),
          leading: Icon(iconLeading),
          onTap: () => onPress(),
        ));
  }
}
