// Events
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_budget/features/expenses/domain/entities/expense.dart';

import '../../../expenses/domain/repositories/expense_repository.dart';

abstract class AnalyticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  LoadAnalytics({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

// States
abstract class AnalyticsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyicsLoaded extends AnalyticsState {
  final List<Expense> expenses;
  final Map<String, double> categoryTotals;
  final double totalAmount;

  AnalyicsLoaded({
    required this.expenses,
    required this.categoryTotals,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [expenses, categoryTotals, totalAmount];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  AnalyticsError( this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
@injectable
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final ExpenseRepository _repository;

  AnalyticsBloc(this._repository) : super(AnalyticsInitial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await _repository.getExpensesByDateRange(
      event.startDate,
      event.endDate,
    );

    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (expenses) {
        final categoryTotals = <String, double>{};
        double totalAmount = 0;

        for (final expense in expenses) {
         categoryTotals[expense.category]=
         (categoryTotals[expense.category] ?? 0) + expense.amount;
          totalAmount += expense.amount;
        }

        emit(
          AnalyicsLoaded(
            expenses: expenses,
            categoryTotals: categoryTotals,
            totalAmount: totalAmount,
          ),
        );
      },
    );
  }
}
