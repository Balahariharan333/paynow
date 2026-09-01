import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class WalletModel extends HiveObject {
  @HiveField(0)
  final double balance;

  @HiveField(1)
  final bool isCardFrozen;

  @HiveField(2)
  final double dailyLimit;

  @HiveField(3)
  final double monthlyLimit;

  @HiveField(4)
  final List<Map<String, String>> linkedBanks;

  WalletModel({
    this.balance = 12450.75,
    this.isCardFrozen = false,
    this.dailyLimit = 50000.0,
    this.monthlyLimit = 200000.0,
    List<Map<String, String>>? linkedBanks,
  }) : linkedBanks = linkedBanks ??
            [
              {
                'bankName': 'HDFC Bank',
                'accountNumber': '•••• 8829',
                'isPrimary': 'true',
              },
              {
                'bankName': 'State Bank of India',
                'accountNumber': '•••• 4120',
                'isPrimary': 'false',
              },
            ];

  WalletModel copyWith({
    double? balance,
    bool? isCardFrozen,
    double? dailyLimit,
    double? monthlyLimit,
    List<Map<String, String>>? linkedBanks,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
      isCardFrozen: isCardFrozen ?? this.isCardFrozen,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      linkedBanks: linkedBanks ?? this.linkedBanks,
    );
  }
}

class WalletModelAdapter extends TypeAdapter<WalletModel> {
  @override
  final int typeId = 2;

  @override
  WalletModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final rawBanks = fields[4] as List?;
    final List<Map<String, String>> parsedBanks = [];
    if (rawBanks != null) {
      for (final item in rawBanks) {
        if (item is Map) {
          parsedBanks.add(item.map((k, v) => MapEntry(k.toString(), v.toString())));
        }
      }
    }

    return WalletModel(
      balance: (fields[0] as num?)?.toDouble() ?? 12450.75,
      isCardFrozen: fields[1] as bool? ?? false,
      dailyLimit: (fields[2] as num?)?.toDouble() ?? 50000.0,
      monthlyLimit: (fields[3] as num?)?.toDouble() ?? 200000.0,
      linkedBanks: parsedBanks.isNotEmpty ? parsedBanks : null,
    );
  }

  @override
  void write(BinaryWriter writer, WalletModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.balance)
      ..writeByte(1)
      ..write(obj.isCardFrozen)
      ..writeByte(2)
      ..write(obj.dailyLimit)
      ..writeByte(3)
      ..write(obj.monthlyLimit)
      ..writeByte(4)
      ..write(obj.linkedBanks);
  }
}
