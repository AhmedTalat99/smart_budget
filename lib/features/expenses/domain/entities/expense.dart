import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String? id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final DateTime? createdAt;

  const Expense({
     this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
     this.createdAt,
  });
  @override
  List<Object?> get props => [id, amount, category, description, date, createdAt];

  Expense copyWith({ //A copy of the object works with a minor modification.
      String? id,
      double? amount,
      String? category,
      String? description,
      DateTime? date,
      DateTime? createdAt, 
       }) {
    return Expense( 
      id:id?? this.id,
      amount: amount?? this.amount,
      category: category?? this.category,
      description: description?? this.description,
      date: date?? this.date,
      createdAt: createdAt?? this.createdAt,
    );
  }
}
