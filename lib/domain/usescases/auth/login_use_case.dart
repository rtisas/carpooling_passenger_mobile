import 'package:carpooling_passenger/data/models/auth/login_response.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/auth/login_request.dart';
import '../../repositories/auth/auth_respository.dart';

class LoginUseCase{
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Either<Failure, LoginResponse>> loginUseCase(LoginRequest userLogin) {
    return authRepository.login(userLogin);
  }
}
