
import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';

abstract class VirtualWalletRepository{
  Future<Either<Failure,VirtualWalletResponse>> getVirtualWalletByPassenegr(String idPassenger );
}