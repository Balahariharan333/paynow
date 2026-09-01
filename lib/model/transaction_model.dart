import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String time;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String amount;

  @HiveField(6)
  final double amountValue;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final bool isPositive;

  @HiveField(9)
  final bool isSuccess;

  @HiveField(10)
  final String initialText;

  @HiveField(11)
  final String utr;

  @HiveField(12)
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'date': date,
      'type': type,
      'amount': amount,
      'amountVal': amountValue,
      'status': status,
      'isPositive': isPositive,
      'isSuccess': isSuccess,
      'initialText': initialText,
      'utr': utr,
      'iconCode': iconCode,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id']?.toString() ?? 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      title: map['title']?.toString() ?? 'Transaction',
      time: map['time']?.toString() ?? 'Just now',
      date: map['date']?.toString() ?? 'Today',
      type: map['type']?.toString() ?? 'Payment',
      amount: map['amount']?.toString() ?? 'Rs 0.00',
      amountValue: (map['amountVal'] as num?)?.toDouble() ?? 0.0,
      status: map['status']?.toString() ?? 'Success',
      isPositive: map['isPositive'] as bool? ?? false,
      isSuccess: map['isSuccess'] as bool? ?? true,
      initialText: map['initialText']?.toString() ?? 'P',
      utr: map['utr']?.toString() ?? 'PAYNOW${DateTime.now().millisecondsSinceEpoch}',
      iconCode: map['iconCode'] as int?,
    );
  }
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String? ?? '',
      title: fields[1] as String? ?? '',
      time: fields[2] as String? ?? '',
      date: fields[3] as String? ?? '',
      type: fields[4] as String? ?? '',
      amount: fields[5] as String? ?? '',
      amountValue: (fields[6] as num?)?.toDouble() ?? 0.0,
      status: fields[7] as String? ?? 'Success',
      isPositive: fields[8] as bool? ?? false,
      isSuccess: fields[9] as bool? ?? true,
      initialText: fields[10] as String? ?? 'P',
      utr: fields[11] as String? ?? '',
      iconCode: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.amountValue)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.isPositive)
      ..writeByte(9)
      ..write(obj.isSuccess)
      ..writeByte(10)
      ..write(obj.initialText)
      ..writeByte(11)
      ..write(obj.utr)
      ..writeByte(12)
      ..write(obj.iconCode);
  }
}
