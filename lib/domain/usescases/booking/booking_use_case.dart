import 'package:carpooling_passenger/data/models/booking/booking_request.dart';
import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/domain/repositories/booking/booking_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';

class BookingUseCase{
  final BookingRepository bookingRepository;

  BookingUseCase(this.bookingRepository);

  Future<Either<Failure, BookingResponse>> createBooking(BookingRequest bookingRequest) {
    return bookingRepository.createBookingRequest(bookingRequest);
  }
}
