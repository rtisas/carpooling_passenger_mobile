import 'package:carpooling_passenger/core/application/enviroment.dart';
import 'package:carpooling_passenger/core/styles/size_config.dart';
import 'package:carpooling_passenger/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/application/patterns.dart';
import '../../../core/styles/app_theme.dart';
import 'controller/auth.controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    SizeConfig(context); // obteniendo el tamaño de pantalla

    return Scaffold(
      appBar: AppBar(
        title: Text('Versión: ${Enviroment.VERSION_APP}.1'),
        centerTitle: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const LogoLogin(),
                  FormLogin(),
                ],
              ),
            ),
            if (authCtrl.loadingAuth.value) const LoadingWidget()
          ],
        ),
      ),
    );
  }
}

class LogoLogin extends StatelessWidget {
  const LogoLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SvgPicture.asset(
        alignment: Alignment.center,
        'assets/logo_pre.svg',
        height: 300,
        width: 200,
      ),
    );
  }
}

class FormLogin extends StatelessWidget {
  final authCtrl = Get.find<AuthController>();
  FormLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: authCtrl.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Iniciar Sesión',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            TextFormField(
              onChanged: (value) {
                authCtrl.userLogin.value.email = value;
              },
              validator: (email) {
                return Patterns.patternEmail().hasMatch(email ?? '')
                    ? null
                    : 'No es un correo electrónico válido';
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  icon: Icon(Icons.alternate_email_rounded),
                  hintText: 'example@email.com'),
            ),
            Obx(() {
              return TextFormField(
                onChanged: (value) {
                  authCtrl.userLogin.value.password = value;
                },
                obscureText: authCtrl.isViewPassword.value,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outlined),
                  hintText: '********',
                  suffixIcon: IconButton(
                    splashRadius: 1,
                    icon: (authCtrl.isViewPassword.value)
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () => authCtrl.isViewPassword.value =
                        !authCtrl.isViewPassword.value,
                  ),
                ),
              );
            }),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: MaterialButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                onPressed: () async {
                  if (await authCtrl.validForm()) {
                    if (await authCtrl.login()) {
                      if ((authCtrl.passenger?.frDestinyLatitude == null ||
                                  authCtrl
                                      .passenger!.frDestinyLatitude!.isEmpty) ||
                              (authCtrl.passenger?.frDestinyLongitude == null ||
                                  authCtrl.passenger!.frDestinyLongitude!
                                      .isEmpty) ||
                              (authCtrl.passenger?.frOriginHour == null ||
                                  authCtrl.passenger!.frOriginHour!.isEmpty) ||
                              (authCtrl.passenger?.frOriginLatitude == null ||
                                  authCtrl
                                      .passenger!.frOriginLatitude!.isEmpty) ||
                              (authCtrl.passenger?.frOriginLongitude == null ||
                                  authCtrl
                                      .passenger!.frOriginLongitude!.isEmpty)
                          // authCtrl.passenger?.pushToken != null &&   //TODO:  implementar firebase para obtener el push token
                          ) {
                        Get.offNamed('/frecuent_profile');
                      } else {
                        Get.offNamed('/home');
                      }
                    } else {
                      Get.closeAllSnackbars();
                      Get.snackbar('Error',
                          authCtrl.error.value?.message ?? "Ocurrió un error");
                    }
                  } else {
                    Get.closeAllSnackbars();
                    Get.snackbar('Error',
                        'Datos incompletos, por favor intente nuevamente');
                  }
                },
                minWidth: double.infinity,
                elevation: 0,
                highlightElevation: 0,
                splashColor: AppTheme.colorSecondaryColor,
                color: AppTheme.colorPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
