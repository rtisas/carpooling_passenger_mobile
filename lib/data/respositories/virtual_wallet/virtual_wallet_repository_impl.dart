import 'package:carpooling_passenger/data/datasources/network/virtual_wallet/virtual_wallet_remote_data_source.dart';
import 'package:carpooling_passenger/data/models/virtual_wallet/history_recharge.dart';
import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';
import 'package:carpooling_passenger/core/errors/failure.dart';
import 'package:carpooling_passenger/domain/repositories/virtual_wallet/virtual_wallet_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/exeptions.dart';

class VirtualWalletRepositoryImpl implements VirtualWalletRepository{

  final VirtualWalletDataSource _virtualWalletDataSource;

  VirtualWalletRepositoryImpl(this._virtualWalletDataSource);

  @override
  Future<Either<Failure, VirtualWalletResponse>> getVirtualWalletByPassenegr(String idPassenger) async {
    try {
      final virtualResponse = await _virtualWalletDataSource.getVirtualWalletByPassenger(idPassenger);
      return Right(virtualResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Algo salió mal, por favor verifique los datos'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(message:'No se encontró la billetera del usuario'));
    } on ServerException {
      return Left(FailureResponse(message: 'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }

  @override
  Future<Either<Failure, List<HisotoryRecharge>>> getHistoryRechargeByPassenger(String idPassenger) async {
   try {
      final listHistoryRecharge = await _virtualWalletDataSource.getHistoryRecharge(idPassenger);
      return Right(listHistoryRecharge);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Algo salió mal, por favor verifique los datos'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(message:'No se encontró la billetera del usuario'));
    } on ServerException {
      return Left(FailureResponse(message: 'Ocurrió un error, consulte con el administrador'));
    }
  }

}