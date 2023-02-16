import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/routes/route_response.dart';

class CardRoute extends StatelessWidget {
  final RouteResponse route;
  const CardRoute({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('detail-route',arguments: route,  );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Card(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                route.nameRoute,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    spacing: 2,
                    children: [
                      ...route.availableDays
                          .split(',')
                          .map((e) => Chip(label: Text(e)))
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(route.availableTime))
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
