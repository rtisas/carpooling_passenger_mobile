import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/booking/booking.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingsAvailablesTab extends StatelessWidget {
  const BookingsAvailablesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingCtrl = Get.find<BookingController>();
    return RefreshIndicator(
      onRefresh: () async {
        await bookingCtrl.loadBookingsActiveByPassenger();
      },
      child: Obx(() {
        return ListView.builder(
          itemCount: bookingCtrl.listBookings.length,
          itemBuilder: (BuildContext context, int index) {
            return _CardBooking(booking: bookingCtrl.listBookings[index]);
          },
        );
      }),
    );
  }
}

class _CardBooking extends StatelessWidget {
  const _CardBooking({
    super.key,
    required this.booking,
  });

  final BookingResponseComplete booking;

  @override
  Widget build(BuildContext context) {
    final bookingCtrl = Get.find<BookingController>();

    return GestureDetector(
      onTap: (){
        Get.toNamed('detail_booking', arguments: booking);
      },
      child: Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Container(
                height: 30,
                color: booking.color,
                child: Center(
                  child: Text('Ruta ${booking.route?.nameRoute}'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Origen',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Text(booking.startStation.nameStation),
                      ),
                      const Text('Destino',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Text(booking.endStation.nameStation),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const Text('Estado',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      Chip(
                        backgroundColor: booking.color,
                        label: Text(booking.state.parameterValue ?? ''),
                      ),
                      if (booking.service != null)
                        Text('Vehículo ${booking.service?.vehicle?.id}')
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: ButtonBar(
                children: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('Confirmación'),
                              content: const Text(
                                  '¿Está seguro de cancelar la reserva?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      bookingCtrl
                                          .deleteBooking(booking.id.toString());
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Aceptar')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'))
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
