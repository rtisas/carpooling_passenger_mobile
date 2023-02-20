import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';
import 'package:carpooling_passenger/domain/repositories/virtual_wallet/virtual_wallet_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';


class VirtualWalletUseCase{

  final VirtualWalletRepository _virtualWalletRepository;

  VirtualWalletUseCase(this._virtualWalletRepository);

  Future<Either<Failure, VirtualWalletResponse>> getVirtualWalletByPassenger(String idPassenger) {
    return _virtualWalletRepository.getVirtualWalletByPassenegr(idPassenger);
  }

}