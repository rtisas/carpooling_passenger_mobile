import 'package:carpooling_passenger/data/models/booking/booking_request.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/booking/booking_response.dart';

abstract class BookingRepository{
  Future<Either<Failure, BookingResponse>> createBookingRequest(BookingRequest bookingRequest);
  Future<Either<Failure, List<BookingResponseComplete>>> getBookingsPassengerByState( String idPassenger, String status);
  Future<Either<Failure, dynamic>> deleteBooking( String idBooking);
}