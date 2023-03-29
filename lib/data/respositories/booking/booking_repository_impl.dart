import 'package:carpooling_passenger/data/datasources/network/booking/booking_remote_data_source.dart';
import 'package:dartz/dartz.dart';

import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/data/models/booking/booking_request.dart';
import 'package:carpooling_passenger/core/errors/failure.dart';
import '../../../core/errors/exeptions.dart';
import '../../../domain/repositories/booking/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository{

  final BookingRemoteDataSource _bookingRemoteDataSource;

  BookingRepositoryImpl(this._bookingRemoteDataSource);

  @override
  Future<Either<Failure, BookingResponse>> createBookingRequest(BookingRequest bookingRequest) async {
    try {
      final bookingResponse = await _bookingRemoteDataSource.createBooking(bookingRequest);
      return Right(bookingResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Algo salió mal, por favor verifique los datos'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(
          message:
              'Ocurrió un error por parte de nosotros, por favor intente más tarde'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }
  
  @override
  Future<Either<Failure, List<BookingResponseComplete>>> getBookingsPassengerByState(String idPassenger, String status) async  {
     try {
      final listBookingResponse = await _bookingRemoteDataSource.getBookingsPassengerByState(idPassenger, status);
      return Right(listBookingResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Algo salió mal, por favor verifique los datos'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return const Right([]);
      // return Left(FailureResponse(message:'Aún no hay reservas disponibles'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }
  
  @override
  Future<Either<Failure, dynamic>> deleteBooking(String idBooking) async {
    try {
      final listBookingResponse = await _bookingRemoteDataSource.deleteBooking(idBooking);
      return Right(listBookingResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Algo salió mal, por favor verifique los datos'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return const Right([]);
      // return Left(FailureResponse(message:'Aún no hay reservas disponibles'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }
  
  @override
  Future<Either<Failure, BookingResponseComplete>> getBookingsById(String idBooking) async {
      try {
      final bookingResponse = await _bookingRemoteDataSource.getBookingById(idBooking);
      return Right(bookingResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Algo salió mal, por favor verifique los datos'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(message: 'La reserva no existe o no se encuentra disponible'));
      // return Left(FailureResponse(message:'Aún no hay reservas disponibles'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }
  
}