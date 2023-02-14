
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/auth/login_request.dart';
import '../../../data/models/auth/login_response.dart';

abstract class AuthRepository{
  Future<Either<Failure, LoginResponse>> login(LoginRequest userLogin);

}