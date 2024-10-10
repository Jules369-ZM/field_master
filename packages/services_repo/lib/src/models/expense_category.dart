import 'package:equatable/equatable.dart';

part 'expense_category.g.dart';

/// {@template expense_category}
/// ExpenseCategory description
/// {@endtemplate}
class ExpenseCategory extends Equatable {
  /// {@macro expense_category}
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.userUid,
    this.parent = 0,
  });

  /// Creates a ExpenseCategory from Json map
  factory ExpenseCategory.fromJson(Map<String, dynamic> data) =>
      _$ExpenseCategoryFromJson(data);

  /// A description for id
  final int id;

  /// A description for name
  final String name;

  /// A description for description
  final String description;

  /// A description for parent
  final int? parent;

  /// A description for user_uid
  final String userUid;

  /// Creates a copy of the current ExpenseCategory with property changes
  ExpenseCategory copyWith({
    int? id,
    String? name,
    String? description,
    int? parent,
    String? userUid,
  }) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parent: parent ?? this.parent,
      userUid: userUid ?? this.userUid,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        parent,
      ];

  /// Creates a Json map from a ExpenseCategory
  Map<String, dynamic> toJson() => _$ExpenseCategoryToJson(this);

  /// Creates a toString() override for ExpenseCategory
  @override
  String toString() =>
      '''ExpenseCategory(id: $id, name: $name, description: $description, parent: $parent)''';
}
