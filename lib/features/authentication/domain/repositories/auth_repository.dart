
import 'package:dartz/dartz.dart';
import 'package:smart_budget/features/authentication/domain/entities/user.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure,User?>> getCurrentUser();
  Future<Either<Failure,User>> signIn({required String email, required String password});
  Future<Either<Failure,User>> signUp({required String email, required String password, required String name});
  Future<Either<Failure,void>> signOut();
  Future<Either<Failure,void>> resetPassword(String email);
}
