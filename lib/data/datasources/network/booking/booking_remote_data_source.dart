import 'package:carpooling_passenger/data/models/booking/booking_request.dart';
import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/data/models/helpers/bookingState.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/exeptions.dart';
import '../web_service.dart';

abstract class BookingRemoteDataSource {
  Future<BookingResponse> createBooking(BookingRequest bookingRequest);
  Future<List<BookingResponseComplete>> getBookingsPassengerByState(
      String idPassenger, String status);
  Future<dynamic> deleteBooking(String idBooking);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final WebService webService;

  BookingRemoteDataSourceImpl(this.webService);

  @override
  Future<BookingResponse> createBooking(BookingRequest bookingRequest) async {
    try {
      final http = await webService.httpClient();
      final response =
          await http.post('facade/post-booking', data: bookingRequest);
      if (response.statusCode == 200) {
        final bookingResponse = BookingResponse.fromJson(response.data);
        return bookingResponse;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }

  @override
  Future<List<BookingResponseComplete>> getBookingsPassengerByState(
      String idPassenger, String status) async {
    try {
      Map<String, dynamic> queryParameters = {
        "idPassenger": idPassenger,
        "status": status
      };
      final http = await webService.httpClient();
      final response = await http.get('facade/get-booking/passenger', queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<BookingResponseComplete> listBookingsResponse = [];
        for (var element in response.data) {
          BookingResponseComplete bookingResponse = BookingResponseComplete.fromJson(element);
          if(bookingResponse.state.id.toString() == STATUS_BOOKING.APROBADO.value){
            bookingResponse.color = Colors.green;
          }else if( bookingResponse.state.id.toString() == STATUS_BOOKING.PENDIENTE.value ){
            print('LOG entra ${ 1 }');
            bookingResponse.color = Color.fromARGB(204, 234, 212, 98);
          }else if( bookingResponse.state.id.toString() == STATUS_BOOKING.EN_EJECUCION.value ){
            bookingResponse.color = Colors.blue;
          }else if( bookingResponse.state.id.toString() == STATUS_BOOKING.FINALIZADO.value){
            bookingResponse.color = Colors.purpleAccent;
          }else if( bookingResponse.state.id.toString() == STATUS_BOOKING.RECHAZADO.value){
            bookingResponse.color = Colors.redAccent;
          }
          listBookingsResponse.add(bookingResponse);
        }
        return listBookingsResponse;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }
  
  @override
  Future<dynamic> deleteBooking(String idBooking)  async {
     try {
      final http = await webService.httpClient();
      final response =
          await http.delete('facade/delete-booking/$idBooking');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
    }
  }
}
