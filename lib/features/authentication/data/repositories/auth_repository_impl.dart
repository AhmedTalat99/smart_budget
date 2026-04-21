import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:smart_budget/core/error/failures.dart';
import 'package:smart_budget/features/authentication/data/models/user_model.dart';

import 'package:smart_budget/features/authentication/domain/entities/user.dart' as domain;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  AuthRepositoryImpl(this._supabase);

  @override
  Future<Either<Failure, domain.User?>> getCurrentUser() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) {
        return const Right(null);
      }
      final user = session.user;
      final userModel = UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
        createdAt: DateTime.parse(user.createdAt),
      );
      return Right(userModel);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        return Left(AuthFailure('Sign in failed'));
      }

      final user = UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        name: response.user!.userMetadata?['name'] as String?,
        createdAt: DateTime.parse(response.user!.createdAt),
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.User>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );

      if (response.user == null) {
        return Left(AuthFailure('Sign up failed'));
      }

      final user = UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        name: name,
        createdAt: DateTime.parse(response.user!.createdAt),
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
