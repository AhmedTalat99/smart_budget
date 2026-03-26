import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_budget/features/authentication/domain/entities/user.dart';
import 'package:smart_budget/features/authentication/domain/repositories/auth_repository.dart';

// ==================== EVENTS ====================
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested(this.email, this.password, this.name);

  @override
  List<Object?> get props => [email, password, name];
}

class SignOutRequested extends AuthEvent {}

// ==================== STATES ====================
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// ==================== BLOC ====================
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  FutureOr<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.getCurrentUser();
      result.fold(
        (failure) => emit(Unauthenticated()),
        (user) =>
            user != null ? emit(Authenticated(user)) : emit(Unauthenticated()),
      );
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  FutureOr<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  FutureOr<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  FutureOr<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
        await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Failed to sign out'));
    }
  }
}
