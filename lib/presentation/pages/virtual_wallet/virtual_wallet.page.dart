import 'package:carpooling_passenger/core/application/helpers.dart';
import 'package:carpooling_passenger/core/styles/size_config.dart';
import 'package:carpooling_passenger/presentation/pages/virtual_wallet/controller/virtual_wallet.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualWalletPage extends StatelessWidget {
  const VirtualWalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);

    final virtualCtrl = Get.find<VirtualWalletController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billetera Virtual'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          await virtualCtrl.getVirtualWalletByPassenger();
          await virtualCtrl.getHisotoryRecharge();
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: const _CustomVirtualWalletWidget()),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: const Text(
                        'Historial de abonos',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                  ...virtualCtrl.historyRecharge.value
                      .map((recharge) => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 19, 73, 20))),
                            child: ListTile(
                              leading: Container(
                                  height: double.infinity,
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: Colors.green,
                                  )),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(recharge.paymentDescription),
                                  Text(recharge.paymentDate),
                                ],
                              ),
                              subtitle: Text(Helpers.formatCurrency(
                                  recharge.paymentValue.toDouble())),
                            ),
                          ))
                      .toList(),
                ],
              );
            })),
      ),
    );
  }
}

class _CustomVirtualWalletWidget extends StatelessWidget {
  const _CustomVirtualWalletWidget();

  @override
  Widget build(BuildContext context) {
    final virtualCtrl = Get.find<VirtualWalletController>();

    return Obx(() {
      return Container(
        child: (virtualCtrl.userContainVirtualWallet.value)
            ? SizedBox(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saldo',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return  AlertDialog(
                                          title: const Text('Información'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text('Para nosotros es importante tu seguridad, es por ello necesario comunicarse a través de los siguientes canales de información para solicitar una recarga de tu billetera virtual.'),
                                              Divider(),
                                              Text('info@rtisas.com.co', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),),
                                              Text('recursosbiiletera@rtisas.com', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Text('Recargar'))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                  Helpers.formatCurrency(virtualCtrl
                                          .virtualWalletPassenger
                                          .value
                                          ?.currentValue
                                          .toDouble() ??
                                      0.0),
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400));
                            }),
                          ],
                        ),
                        Obx(() {
                          return RichText(
                            text: TextSpan(
                              text: 'Tú última recarga fue de: ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '\$${virtualCtrl.virtualWalletPassenger.value?.lastRechargeValue}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              )
            : Center(child: Text('Billetera no disponible')),
      );
    });
  }
}
