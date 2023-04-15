
import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/virtual_wallet/history_recharge.dart';

abstract class VirtualWalletRepository{
  Future<Either<Failure,VirtualWalletResponse>> getVirtualWalletByPassenegr(String idPassenger );
  Future<Either<Failure,List<HisotoryRecharge>>> getHistoryRechargeByPassenger(String idPassenger);
}