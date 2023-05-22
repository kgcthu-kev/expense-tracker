import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpenses = [
    Expense(
        title: 'Bangkok',
        amount: 99.99,
        category: Category.leisure,
        date: DateTime.now()),
    Expense(
        title: 'Moke Hingar',
        amount: 20.99,
        category: Category.food,
        date: DateTime.now())
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerExpenses.indexOf(expense);
    setState(() {
      _registerExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense deleted.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registerExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registerExpenses.isNotEmpty) {
      mainContent = ExpenseList(
          expenses: _registerExpenses, removeExpense: _removeExpense);
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
          ],
          title: const Text('Expense tracker'),
        ),
        body: Column(children: [
          Chart(expenses: _registerExpenses),
          Expanded(child: mainContent)
        ]));
  }
}
