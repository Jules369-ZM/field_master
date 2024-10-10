part of 'expense_category.dart';

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) =>
    ExpenseCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      parent: json['parent'] as int? ?? 0,
      userUid: json['user_uid'] as String? ?? '',
    );

Map<String, dynamic> _$ExpenseCategoryToJson(ExpenseCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'parent': instance.parent ?? 0,
       'user_uid': instance.userUid,
    };
