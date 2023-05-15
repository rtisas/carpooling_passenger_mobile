import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/data/models/helpers/bookingState.dart';
import 'package:carpooling_passenger/data/models/helpers/statusService.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/booking/booking.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../core/application/helpers.dart';

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
        return (bookingCtrl.isLoading.value)
            ? const Center(child: CircularProgressIndicator())
            : Builder(builder: (context) {
                if (bookingCtrl.listBookings.value.isEmpty) {
                  return const Center(
                    child: Text('No tienes reservas aún'),
                  );
                }
                return ListView.builder(
                  physics: (bookingCtrl.listBookings.value.length <= 3)
                      ? const AlwaysScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  itemCount: bookingCtrl.listBookings.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _CardBooking(
                        booking: bookingCtrl.listBookings.value[index]);
                  },
                );
              });
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
      onTap: () {
        Get.toNamed('detail_booking', arguments: booking);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Container(
                height: 40,
                // color: booking.color,
                child: Center(
                  child: Text(
                      'Servicio ${booking.service?.nameService ?? 'pendiente'}, con ruta ${booking.route?.nameRoute}'),
                ),
              ),
            ),
            Divider(),
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
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Chip(
                        backgroundColor: booking.color,
                        label: Text(changePhrase(booking.state.id)),
                      ),
                      if (booking.service != null)
                        Text('Vehículo ${booking.service?.vehicle?.plate}'),
                      Text('Precio ${Helpers.formatCurrency(double.parse(booking.route?.price ?? '0' ))}')
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: ButtonBar(
                children: [
                  if (booking.state.id.toString() ==
                          STATUS_BOOKING.EN_EJECUCION.value ||
                      booking.state.id.toString() ==
                          STATUS_BOOKING.FINALIZADO.value)
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return QualifiyingBookingWidget(
                                    booking: booking);
                              });
                        },
                        child: const Text('Calificar servicio')),
                  if (booking.state.id.toString() !=
                      STATUS_BOOKING.EN_EJECUCION.value)
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
                                        bookingCtrl.deleteBooking(
                                            booking.id.toString());
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
            ),
            if (booking.service?.state.id == STATUS_SERVICE.EN_EJECUCION.value)
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.bus_alert,
                      color: Colors.white,
                    ),
                    Text(
                      '¡El vehículo está en camino!',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
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

class QualifiyingBookingWidget extends StatefulWidget {
  const QualifiyingBookingWidget({
    super.key,
    required this.booking,
  });

  final BookingResponseComplete booking;

  @override
  State<QualifiyingBookingWidget> createState() =>
      _QualifiyingBookingWidgetState();
}

class _QualifiyingBookingWidgetState extends State<QualifiyingBookingWidget> {
  String qualifiyingValue = '';

  @override
  Widget build(BuildContext context) {
    final bookingCtrl = Get.find<BookingController>();

    return AlertDialog(
      title: const Text('¿Qué tal te parece el servicio?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: RatingBar.builder(itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return const Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  );
                case 2:
                  return const Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
                case 3:
                  return const Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
                default:
                  return Container();
              }
            }, onRatingUpdate: (rating) {
              qualifiyingValue = rating.toString();
              setState(() {});
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (qualifiyingValue != "0.0" && qualifiyingValue.length > 0) {
                bookingCtrl.updateQualifyingService(
                    widget.booking.id.toString(), qualifiyingValue);
              }
              Navigator.pop(context);
            },
            child: const Text('Enviar Calificación'))
      ],
    );
  }
}

String changePhrase(int idStateParameterBooking) {
  if (idStateParameterBooking.toString() == STATUS_BOOKING.EN_EJECUCION.value) {
    return 'Abordo';
  } else if (idStateParameterBooking.toString() ==
      STATUS_BOOKING.APROBADO.value) {
    return 'Aprobado';
  } else if (idStateParameterBooking.toString() ==
      STATUS_BOOKING.PENDIENTE.value) {
    return 'Pendiente';
  }
  return '';
}
