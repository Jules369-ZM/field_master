part of 'expense.dart';

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      date: json['date'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      id: json['id'] as int,
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      userUid: json['user_uid'] as String? ?? '',
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
      'category': instance.category,
      'image': instance.image,
      'id': instance.id,
      'description': instance.description,
      'location': instance.location,
      'user_uid': instance.userUid,
    };
