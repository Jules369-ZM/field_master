import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';

class TxBarChart extends StatelessWidget {
  const TxBarChart(this.barGroups, {required this.periods, super.key});

  factory TxBarChart.withData(
    List<Expense> transactions, {
    String filter = 'Weekly',
  }) {
    final income = <JsonMap>[];
    final expenses = <JsonMap>[];

    var format = 'EEE';

    switch (filter) {
      case 'Monthly':
        format = 'MMM';
      case 'Yearly':
        format = 'y';
      default:
        format = 'EEE';
    }

    var txs = List<Expense>.from(transactions);
    if (format == 'EEE') {
      txs = txs
          .where(
            (element) => DateTime.parse(element.date)
                .isAfter(DateTime.now().subtract(const Duration(days: 7))),
          )
          .toList();
    }

    for (final tx in txs) {
      final period = DateFormat(format).format(
        tx.date.isNotEmpty ? DateTime.parse(tx.date) : DateTime.now(),
      );
      expenses.add(<String, dynamic>{
        'period': period,
        'amount': double.parse(tx.amount),
      });
    }

    final periods = <String>{
      ...income.map((e) => e['period'] as String),
      ...expenses.map((e) => e['period'] as String),
    };

    return TxBarChart(
      _createData(income, expenses, periods),
      periods: periods.toList(),
    );
  }

  final List<BarChartGroupData> barGroups;
  final List<String> periods;

  /// Create series list with multiple series
  static List<BarChartGroupData> _createData(
    List<JsonMap> income,
    List<JsonMap> expenses,
    Set<String> periods,
  ) {
    final incomeData = <String, double>{};
    for (final inc in income) {
      if (incomeData.containsKey(inc['period'])) {
        incomeData[inc['period'].toString()] =
            incomeData[inc['period'].toString()]! +
                double.parse(inc['amount'].toString());
      } else {
        incomeData[inc['period'] as String] = inc['amount'] as double;
      }
    }
    final expensesData = <String, double>{};
    for (final exp in expenses) {
      if (expensesData.containsKey(exp['period'])) {
        expensesData[exp['period'].toString()] =
            expensesData[exp['period'].toString()]! +
                double.parse(exp['amount'].toString());
      } else {
        expensesData[exp['period'] as String] = exp['amount'] as double;
      }
    }
    final data = List.generate(
      periods.length,
      (index) => BarChartGroupData(
        x: index,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
            toY: incomeData.containsKey(periods.elementAt(index))
                ? incomeData[periods.elementAt(index)]!
                : 0,
            color: Colors.greenAccent,
            width: 12,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: expensesData.containsKey(periods.elementAt(index))
                  ? expensesData[periods.elementAt(index)]!
                  : 0,
              color: Colors.greenAccent.shade100.withOpacity(0.1),
            ),
          ),
          BarChartRodData(
            toY: expensesData.containsKey(periods.elementAt(index))
                ? expensesData[periods.elementAt(index)]!
                : 0,
            color: Colors.redAccent,
            width: 12,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: incomeData.containsKey(periods.elementAt(index))
                  ? incomeData[periods.elementAt(index)]!
                  : 0,
              color: Colors.redAccent.shade100.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return barGroups.isEmpty
        ? const Center(child: Text('No data for this period'))
        : BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 16, //margin top
                        child: Text(periods[value.toInt()]),
                      );
                    },
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
            ),
          );
  }
}
