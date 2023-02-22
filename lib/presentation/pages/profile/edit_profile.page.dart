import 'dart:io';

import 'package:carpooling_passenger/presentation/pages/profile/controller/profile.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/application/patterns.dart';
import '../home/controller/home.controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final passegerProfileCtrl = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Obx(() {
                        //si contiene mayor a 1 es porque selecciono una imagen de la galería
                        return (passegerProfileCtrl.image.value.isNotEmpty)
                            ? CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(
                                  File(passegerProfileCtrl.image.value),
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(homeCtrl.user
                                        .value?.basicData.profilePicture?.url ??
                                    'https://simtaru.tasikmalayakota.go.id/images/headline.jpg'),
                                backgroundColor: Colors.transparent,
                                radius: 80,
                              );
                      }),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 228, 228, 228),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: IconButton(
                            onPressed: () async {
                              passegerProfileCtrl.pickImageFromGallery();
                            },
                            icon: const Icon(Icons.add_a_photo),
                          )),
                    )
                  ],
                ),
              ),
              _FormEditUserPasseger(
                  passegerProfileCtrl: passegerProfileCtrl, homeCtrl: homeCtrl),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormEditUserPasseger extends StatefulWidget {
  const _FormEditUserPasseger({
    required this.passegerProfileCtrl,
    required this.homeCtrl,
  });

  final ProfileController passegerProfileCtrl;
  final HomeController homeCtrl;

  @override
  State<_FormEditUserPasseger> createState() => _FormEditUserPassegerState();
}

class _FormEditUserPassegerState extends State<_FormEditUserPasseger> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      onChanged: () {
        setState(() {});
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              onChanged: (value) {
                widget.passegerProfileCtrl.userUpdate.value
                    .addAll({'email': value});
                _formKey.currentState!.validate();
              },
              validator: (value) {
                return Patterns.patternEmail().hasMatch(value ?? '')
                    ? null
                    : 'Email no válido';
              },
              initialValue: widget.homeCtrl.user.value?.basicData.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text('Correo electrónico'),
                  border: OutlineInputBorder(),
                  hintText: 'example@email.com'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              onChanged: (value) {
                widget.passegerProfileCtrl.userUpdate.value
                    .addAll({'firstName': value});
                _formKey.currentState!.validate();
              },
              validator: (value) {
                return Patterns.validateField(value ?? '', 2, 50,
                    Patterns.patternName(), 'El nombre no es válido');
              },
              initialValue: widget.homeCtrl.user.value?.basicData.firstName,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text('Nombre(s)'),
                  border: OutlineInputBorder(),
                  hintText: 'Nombre completo'),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              onChanged: (value) {
                widget.passegerProfileCtrl.userUpdate.value
                    .addAll({'lastName': value});
                _formKey.currentState!.validate();
              },
              validator: (value) {
                return Patterns.validateField(value ?? '', 2, 50,
                    Patterns.patternName(), 'El apellido no es válido');
              },
              initialValue: widget.homeCtrl.user.value?.basicData.lastName,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text('Apellido(s)'),
                  border: OutlineInputBorder(),
                  hintText: 'Nombre completo'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              onChanged: (value) {
                widget.passegerProfileCtrl.userUpdate.value
                    .addAll({'phoneNumber': value});
                _formKey.currentState!.validate();
              },
              validator: (value) {
                return Patterns.patternNumbers().hasMatch(value ?? '')
                    ? null
                    : 'No es un número de teléfono válido';
              },
              initialValue: widget.homeCtrl.user.value?.basicData.phoneNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  label: Text('Teléfono'),
                  border: OutlineInputBorder(),
                  hintText: 'Número de teléfono'),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, bottom: 30),
            child: MaterialButton(
                padding: EdgeInsets.all(10),
                shape: const StadiumBorder(),
                elevation: 0,
                color: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState?.validate() != null && _formKey.currentState?.validate() == true) {
                    widget.passegerProfileCtrl.updatePassager(widget.homeCtrl);
                    // Aquí puedes guardar los datos ingresados en el formulario.
                  } else {
                  }
                },
                child: const Text('Guardar')),
          )
        ],
      ),
    );
  }
}
