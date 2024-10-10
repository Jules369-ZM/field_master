import 'package:equatable/equatable.dart';

part 'expense.g.dart';

/// {@template expense}
/// Expense description
/// {@endtemplate}
class Expense extends Equatable {
  /// {@macro expense}
  const Expense({
    required this.date,
    required this.amount,
    required this.category,
    required this.image,
    required this.id,
    required this.description,
    required this.location,
    required this.userUid,
  });

  /// Creates a Expense from Json map
  factory Expense.fromJson(Map<String, dynamic> data) =>
      _$ExpenseFromJson(data);

  /// A description for date
  final String date;

  /// A description for amount
  final String amount;

  /// A description for category
  final String category;

  /// A description for image
  final String image;

  /// A description for id
  final int id;

  /// A description for description
  final String description;

  /// A description for location
  final String location;

  /// A description for user_uid
  final String userUid;

  /// Creates a copy of the current Expense with property changes
  Expense copyWith({
    String? date,
    String? amount,
    String? category,
    String? image,
    int? id,
    String? description,
    String? location,
    String? userUid,
  }) {
    return Expense(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      image: image ?? this.image,
      id: id ?? this.id,
      description: description ?? this.description,
      location: location ?? this.location,
      userUid: userUid ?? this.userUid,
    );
  }

  @override
  List<Object?> get props => [
        date,
        amount,
        category,
        image,
        id,
        description,
        location,
        userUid,
      ];

  /// Creates a Json map from a Expense
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  /// Creates a toString() override for Expense
  @override
  String toString() =>
      '''Expense(date: $date, amount: $amount, category: $category, image: $image, id: $id, description: $description, location: $location)''';
}
