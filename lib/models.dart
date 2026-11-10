import 'package:flutter/material.dart';

class Network {
  final String id;
  final String name;
  final Color color;
  final Color onColor;
  const Network(this.id, this.name, this.color, {this.onColor = Colors.white});
  String get initial => name.substring(0, 1).toUpperCase();
}

const List<Network> networks = [
  Network('1', 'MTN', Color(0xFFFFCB05), onColor: Colors.black87),
  Network('2', 'Airtel', Color(0xFFE40000)),
  Network('3', 'Glo', Color(0xFF4CAF50)),
  Network('4', '9mobile', Color(0xFF007A33)),
];

class DataPlan {
  final String id;
  final String size;
  final String validity;
  final double price;
  const DataPlan(this.id, this.size, this.validity, this.price);
}

const List<DataPlan> dataPlans = [
  DataPlan('1', '500MB', '1 day', 150),
  DataPlan('2', '1GB', '1 day', 250),
  DataPlan('3', '2GB', '30 days', 750),
  DataPlan('4', '5GB', '30 days', 1500),
  DataPlan('5', '10GB', '30 days', 2800),
];

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCredit;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}
