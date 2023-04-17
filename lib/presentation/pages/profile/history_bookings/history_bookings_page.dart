import 'package:carpooling_passenger/core/application/helpers.dart';
import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/presentation/pages/profile/history_bookings/controller/history_bookings.controller.dart';
import 'package:carpooling_passenger/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryBookingsPage extends StatelessWidget {
  const HistoryBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrlHisotryBookings = Get.find<HistoryBookingsController>();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Historial de reservas'),
        ),
        body: Obx(() {
          return (ctrlHisotryBookings.isLoading.value)
              ? const LoadingWidget()
              : Builder(builder: (context) {
                  if (ctrlHisotryBookings.historyBookings.value.isEmpty) {
                    return const Center(
                      child: Text('Aún no hay reservas disponibles'),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: ()async {
                      await ctrlHisotryBookings.getHistoryBookingsPassenger();

                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: ctrlHisotryBookings.historyBookings.value.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _CardBooking(
                                ctrlHisotryBookings.historyBookings.value[index]),
                            const Divider(
                              height: 30,
                            )
                          ],
                        );
                      },
                    ),
                  );
                });
        }));
  }
}

class _CardBooking extends StatelessWidget {
  final BookingResponseComplete booking;
  const _CardBooking(this.booking);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          height: double.infinity, child: Icon(Icons.emoji_transportation)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Servicio ${booking.service?.nameService ?? '-'} con ruta ${booking.route?.nameRoute ?? '-'}',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          Divider(color: Color.fromARGB(77, 68, 137, 255)),
          Row(
            children: [
              const Expanded(
                  flex: 1,
                  child: Text(
                    'Parada de inicio: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    '${booking.startStation.nameStation} - ${booking.startStation.address}',
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  )),
            ],
          ),
          Row(
            children: [
              const Expanded(
                  flex: 1,
                  child: Text(
                    'Parada de destino: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    '${booking.endStation.nameStation} - ${booking.endStation.address}',
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(Icons.calendar_month),
              Expanded(
                  child: Text(
                '${booking.dateBooking}',
                style: const TextStyle(fontWeight: FontWeight.w400),
              )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(Icons.access_time_outlined),
              Expanded(
                  child: Text(
                '${booking.timeBooking}',
                style: const TextStyle(fontWeight: FontWeight.w400),
              )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                ),
              ),
              Text(Helpers.formatCurrency(
                  double.parse(booking.service?.servicePrice ?? '0.0'))),
            ],
          ),
        ],
      ),
    );
  }
}
