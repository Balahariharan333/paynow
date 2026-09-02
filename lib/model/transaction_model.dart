import 'dart:convert';

class TransactionModel {
  final String id;
  final String title;
  final String time;
  final String date;
  final String type;
  final String amount;
  final double amountValue;
  final String status;
  final bool isPositive;
  final bool isSuccess;
  final String initialText;
  final String utr;
  final int? iconCode;

  TransactionModel({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.type,
    required this.amount,
    required this.amountValue,
    this.status = 'Success',
    required this.isPositive,
    this.isSuccess = true,
    this.initialText = 'P',
    required this.utr,
    this.iconCode,
  });

  TransactionModel copyWith({
    String? id,
    String? title,
    String? time,
    String? date,
    String? type,
    String? amount,
    double? amountValue,
    String? status,
    bool? isPositive,
    bool? isSuccess,
    String? initialText,
    String? utr,
    int? iconCode,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      date: date ?? this.date,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      amountValue: amountValue ?? this.amountValue,
      status: status ?? this.status,
      isPositive: isPositive ?? this.isPositive,
      isSuccess: isSuccess ?? this.isSuccess,
      initialText: initialText ?? this.initialText,
      utr: utr ?? this.utr,
      iconCode: iconCode ?? this.iconCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'date': date,
      'type': type,
      'amount': amount,
      'amountValue': amountValue,
      'amountVal': amountValue,
      'status': status,
      'isPositive': isPositive,
      'isSuccess': isSuccess,
      'initialText': initialText,
      'utr': utr,
      'iconCode': iconCode,
    };
  }

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    final rawAmountValue = map['amountValue'] ?? map['amountVal'];

    bool parseBool(dynamic val, bool defaultValue) {
      if (val == null) return defaultValue;
      if (val is bool) return val;
      final str = val.toString().toLowerCase();
      if (str == 'true' || str == '1') return true;
      if (str == 'false' || str == '0') return false;
      return defaultValue;
    }

    return TransactionModel(
      id: map['id']?.toString() ?? 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      title: map['title']?.toString() ?? 'Transaction',
      time: map['time']?.toString() ?? 'Just now',
      date: map['date']?.toString() ?? 'Today',
      type: map['type']?.toString() ?? 'Payment',
      amount: map['amount']?.toString() ?? 'Rs 0.00',
      amountValue: (rawAmountValue as num?)?.toDouble() ?? 0.0,
      status: map['status']?.toString() ?? 'Success',
      isPositive: parseBool(map['isPositive'], false),
      isSuccess: parseBool(map['isSuccess'], true),
      initialText: map['initialText']?.toString() ?? 'P',
      utr: map['utr']?.toString() ?? 'PAYNOW${DateTime.now().millisecondsSinceEpoch}',
      iconCode: (map['iconCode'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel.fromMap(json);

  String toRawJson() => jsonEncode(toMap());

  factory TransactionModel.fromRawJson(String source) =>
      TransactionModel.fromMap(jsonDecode(source) as Map<dynamic, dynamic>);

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, status: $status, utr: $utr)';
  }
}
