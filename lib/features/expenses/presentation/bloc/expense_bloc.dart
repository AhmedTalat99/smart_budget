import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_budget/features/expenses/domain/entities/expense.dart';

import '../../domain/repositories/expense_repository.dart';

// Events
abstract class ExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpenses extends ExpenseEvent {
  final Expense expense;

  AddExpenses(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String id;

  DeleteExpense(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class ExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpenseLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpenseOperationSuccess extends ExpenseState {
  final String message;

  ExpenseOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
@injectable
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;

  ExpenseBloc(this._repository) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);// When a LoadExpenses event occurs, enable the _onLoadExpenses function.
    on<AddExpenses>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  FutureOr<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    final result = await _repository.getExpenses();
    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expenses) => emit(ExpenseLoaded(expenses)),
    );
  }

  FutureOr<void> _onAddExpense(
    AddExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    final result = await _repository.addExpense(event.expense);
    result.fold((failure) => emit(ExpenseError(failure.message)), (_) {
      emit(ExpenseOperationSuccess('  Expense added successfully'));
      add(LoadExpenses());
    });
  }

  FutureOr<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    final result = await _repository.updateExpense(event.expense);
    result.fold((failure) => emit(ExpenseError(failure.message)), (_) {
      emit(ExpenseOperationSuccess('Expense updated successfully'));
      add(LoadExpenses());
    });
  }

  FutureOr<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    final result = await _repository.deleteExpense(event.id);
    result.fold((failure) => emit(ExpenseError(failure.message)), (_) {
      emit(ExpenseOperationSuccess('Expense deleted successfully'));
      add(LoadExpenses());
    });
  }
}
