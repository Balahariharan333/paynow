import 'dart:convert';

class WalletModel {
  final double balance;
  final bool isCardFrozen;
  final double dailyLimit;
  final double monthlyLimit;
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

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'isCardFrozen': isCardFrozen,
      'dailyLimit': dailyLimit,
      'monthlyLimit': monthlyLimit,
      'linkedBanks': linkedBanks,
    };
  }

  factory WalletModel.fromMap(Map<dynamic, dynamic> map) {
    final rawBanks = map['linkedBanks'] as List?;
    final List<Map<String, String>> parsedBanks = [];
    if (rawBanks != null) {
      for (final item in rawBanks) {
        if (item is Map) {
          parsedBanks.add(item.map((k, v) => MapEntry(k.toString(), v.toString())));
        }
      }
    }

    bool parseBool(dynamic val, bool defaultValue) {
      if (val == null) return defaultValue;
      if (val is bool) return val;
      final str = val.toString().toLowerCase();
      if (str == 'true' || str == '1') return true;
      if (str == 'false' || str == '0') return false;
      return defaultValue;
    }

    return WalletModel(
      balance: (map['balance'] as num?)?.toDouble() ?? 12450.75,
      isCardFrozen: parseBool(map['isCardFrozen'], false),
      dailyLimit: (map['dailyLimit'] as num?)?.toDouble() ?? 50000.0,
      monthlyLimit: (map['monthlyLimit'] as num?)?.toDouble() ?? 200000.0,
      linkedBanks: rawBanks != null ? parsedBanks : null,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      WalletModel.fromMap(json);

  String toRawJson() => jsonEncode(toMap());

  factory WalletModel.fromRawJson(String source) =>
      WalletModel.fromMap(jsonDecode(source) as Map<dynamic, dynamic>);

  @override
  String toString() {
    return 'WalletModel(balance: $balance, isCardFrozen: $isCardFrozen, dailyLimit: $dailyLimit, monthlyLimit: $monthlyLimit, linkedBanks: $linkedBanks)';
  }
}
