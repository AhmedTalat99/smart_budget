
import 'package:dartz/dartz.dart';
import 'package:smart_budget/core/error/failures.dart';
import 'package:smart_budget/features/expenses/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();
  Future<Either<Failure,Expense>> addExpense(Expense expense);
  Future<Either<Failure,Expense>> updateExpense(Expense expense);
  Future<Either<Failure,void>> deleteExpense(String id);
  Future<Either<Failure,List<Expense>>>getExpensesByDateRange(DateTime start, DateTime end);
}