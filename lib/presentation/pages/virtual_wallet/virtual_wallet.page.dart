import 'package:carpooling_passenger/core/styles/size_config.dart';
import 'package:carpooling_passenger/presentation/pages/virtual_wallet/controller/virtual_wallet.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualWalletPage extends StatelessWidget {
  const VirtualWalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final virtualCtrl = Get.find<VirtualWalletController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billetera Virtual'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print('LOG valor refresh ${1}');
          await Future.delayed(Duration(seconds: 3));

          virtualCtrl.getVirtualWalletByPassenger();
        },
        child: ListView(
          children: [
            SizedBox(
              width: SizeConfig.safeBlockSizeHorizontal(90),
              height: SizeConfig.safeBlockSizeHorizontal(40),
              child: Card(
                // margin: const EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.all(10),
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
                              onPressed: () {}, child: Text('Recargar'))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Chip(label: Text('COP'), elevation: 0),
                          Obx(() {
                              return Text(
                                  '\$${virtualCtrl.virtualWalletPassenger.value?.currentValue}',
                                  style: const TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.w400));
                            }
                          ),
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
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text('VirtualWalletPage'),
            ),
          ],
        ),
      ),
    );
  }
}
