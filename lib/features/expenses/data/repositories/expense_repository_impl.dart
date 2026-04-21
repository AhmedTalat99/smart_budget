import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_budget/core/error/failures.dart';
import 'package:smart_budget/features/expenses/data/models/expense_model.dart';
import 'package:smart_budget/features/expenses/domain/entities/expense.dart';
import 'package:smart_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final SupabaseClient _supabase;

  ExpenseRepositoryImpl(this._supabase);

  @override
  Future<Either<Failure, Expense>> addExpense(Expense expense) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      final expenseModel = ExpenseModel(
        amount: expense.amount,
        category: expense.category,
        description: expense.description,
        date: expense.date,
      );
      final data = expenseModel.toJson()..['user_id'] = userId;

      final response = await _supabase
          .from('expenses')
          .insert(data)
          .select()
          .single();
      return Right(ExpenseModel.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async{
   try{
    await _supabase.from('expenses').delete().eq('id', id);
    return const Right(null);
   } catch (e) {
    return left(ServerFailure(e.toString()));
   }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(AuthFailure('User not authenticated'));
      }
      final response = await _supabase
          .from('expenses')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false);

      final expenses = (response as List)
          .map((json) => ExpenseModel.fromJson(json))
          .toList();
      return Right(expenses);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try{
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(AuthFailure('User not authenticated'));
      }
      final response = await _supabase.from('expenses')
      .select()
      .eq('user_id',  userId)
      .gte('date', start.toIso8601String())
      .lte('date', end.toIso8601String())
      .order('date', ascending: false);

      final expenses = (response as List)
      .map((json)=>ExpenseModel.fromJson(json))
      .toList();
      return Right(expenses);
    }
    catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    try {
      if (expense.id == null) {
        return Left(ServerFailure('Expense ID is required'));
      }
      final expenseModel = ExpenseModel(
        id: expense.id,
        amount: expense.amount,
        category: expense.category,
        description: expense.description,
        date: expense.date,
      );
      final response = await _supabase
          .from('expenses')
          .update(expenseModel.toJson())
          .eq('id', expense.id!)
          .select()
          .single();
      return Right(ExpenseModel.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
