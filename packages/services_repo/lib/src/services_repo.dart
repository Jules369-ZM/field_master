// ignore_for_file: unused_field

import 'dart:async';
import 'dart:developer';

import 'package:local_data/local_data.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/src/models/models.dart';

/// {@template services_repo}
/// Repo for application services
/// {@endtemplate}
class ServicesRepo {
  /// {@macro services_repo}
  ServicesRepo._(this._config);

  final Config _config;

  // Shared preferences keys
  final String _keyToken = 'token';
  final String _keyCurrentToken = 'services_token';

  final String _tblExpenses = 'expenses';
  final String _tblExpensesCategory = 'expense_category';

  late LocalData _db;
  late NetSource _net;
  late SharedPrefs _prefs;

  /// Public factory
  static Future<ServicesRepo> init(Config config) async {
    final repo = ServicesRepo._(config);
    await repo._init();
    return repo;
  }

  Future<void> _init() async {
    _db = await LocalData.init(
      dbName: _config.dbName,
      initialScript: _config.initScript,
      migrations: _config.migrations,
    );
    _prefs = await SharedPrefs.init();
    await _initNetworkApi();
  }

  Future<void> _initNetworkApi({String? token}) async {
    token ??= await _prefs.getString(_keyToken);
    _net = await NetSource.init(
      baseUrl: _config.baseUrl,
      socketUrl: _config.socketUrl,
      host: _config.host,
      token: token,
    );
  }

  final String _keyUserUId = 'user_uid';

  /// Pipe function to check if token has been refreshed
  Future<dynamic> callService(Future<dynamic> Function() nextFunction) async {
    final token = await _prefs.getString(_keyToken);
    final currentToken = await _prefs.getString(_keyCurrentToken);
    if (currentToken != token) {
      await _initNetworkApi();
    }
    final response = await nextFunction.call() as OpStatus?;
    if (response?.code == 700) {
      log('Session Expired');
      _authController.add(700);
    }
    return response;
  }

  final _authController = StreamController<int>.broadcast();

  /// App auth state to indicate when a user session has expired
  Stream<int> get authState async* {
    yield 0;
    yield* _authController.stream;
  }

  ///inserts Expenses
  Future<OpStatus?> insertExpenses(JsonMap expense) async {
    await _db.insertOne(_tblExpenses, expense);
    return OpStatus(message: 'Successful ', success: true);
  }

  ///get expenses
  Future<List<Expense>> getExpenses() async {
    // final data = await _db.getAll(_tblExpenses);
    // return data.map(Expense.fromJson).toList();
    return [];
  }

  ///get expenses
  Future<List<Expense>> deleteExpense(String id) async {
    await _db.deleteOne(_tblExpenses, int.parse(id));
    final data = await _db.getAll(_tblExpenses);
    return data.map(Expense.fromJson).toList();
  }

  ///inserts Expenses
  Future<OpStatus?> insertCategory(ExpenseCategory category) async {
    await _db.insertOne(_tblExpensesCategory, category.toJson());
    return OpStatus(message: 'Successful ', success: true);
  }

  ///inserts Expenses
  Future<OpStatus?> insertDefaultCategory() async {
    final uid = await _prefs.getString(_keyUserUId);
    final data = <ExpenseCategory>[
      ExpenseCategory(
        id: 1,
        name: 'Food',
        description: 'Drinks',
        userUid: uid!,
      ),
      ExpenseCategory(
        id: 2,
        name: 'Transportation',
        description: 'Traveling',
        userUid: uid,
      ),
      ExpenseCategory(
        id: 3,
        name: 'Entertainment',
        description: 'a means of amusement or recreation',
        userUid: uid,
      ),
    ];
    await _db.insertAll(
      _tblExpensesCategory,
      data.map((e) => e.toJson()).toList(),
    );

    return OpStatus(message: 'Successful ', success: true);
  }

  ///get expense categories
  Future<List<ExpenseCategory>> getExpenseCategory() async {
    final data = await _db.getAll(_tblExpensesCategory);
    return data.map(ExpenseCategory.fromJson).toList();
  }
}
