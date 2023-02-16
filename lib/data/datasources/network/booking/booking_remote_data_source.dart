import 'package:carpooling_passenger/data/models/booking/booking_request.dart';
import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exeptions.dart';
import '../web_service.dart';

abstract class BookingRemoteDataSource {
  Future<BookingResponse> createBooking(BookingRequest bookingRequest);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource{
  final WebService webService;

  BookingRemoteDataSourceImpl(this.webService);

  @override
  Future<BookingResponse> createBooking(BookingRequest bookingRequest) async {
   try {
      final http = await webService.httpClient();
      final response = await http.post('facade/post-booking', data: bookingRequest);
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

}
