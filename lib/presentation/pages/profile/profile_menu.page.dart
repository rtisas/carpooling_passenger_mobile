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
    return Scaffold(body: Builder(builder: (context) {
      return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 5),
              child: Obx(() {
                return CircleAvatar(
                  backgroundImage: NetworkImage(
                      homeCtrl.user.value!.basicData.profilePicture?.url ?? ''),
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
              title: 'Mis reservas',
              iconLeading: Icons.calendar_month_outlined,
              onPress: () {
                print('LOG press Mis reservas ${1}');
              },
            ),
            OptionProfile(
              title: 'Historial de servicios',
              iconLeading: Icons.history,
              onPress: () {
                Get.toNamed('history-services');
              },
            ),
            OptionProfile(
              title: 'Promociones',
              iconLeading: Icons.topic_outlined,
              onPress: () {
                print('LOG press Promociones ${1}');
              },
            ),
            OptionProfile(
              title: 'Cerrar Sesión',
              iconLeading: Icons.exit_to_app_outlined,
              onPress: () async {
                await Preferences.storage.deleteAll();
                Get.offAll(const LoginPage());
              },
            )
          ],
        ),
      ));
    }));
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
