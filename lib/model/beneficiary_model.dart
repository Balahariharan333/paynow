import 'dart:convert';

class BeneficiaryModel {
  final String name;
  final String detail;
  final bool isBank;
  final String? bank;

  BeneficiaryModel({
    required this.name,
    required this.detail,
    required this.isBank,
    this.bank,
  });

  BeneficiaryModel copyWith({
    String? name,
    String? detail,
    bool? isBank,
    String? bank,
  }) {
    return BeneficiaryModel(
      name: name ?? this.name,
      detail: detail ?? this.detail,
      isBank: isBank ?? this.isBank,
      bank: bank ?? this.bank,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'detail': detail,
      'isBank': isBank,
    };
    if (bank != null) {
      map['bank'] = bank!;
    }
    return map;
  }

  Map<String, String> toRecipientMap() {
    final map = <String, String>{
      'name': name,
      'detail': detail,
    };
    if (bank != null) {
      map['bank'] = bank!;
    }
    return map;
  }

  factory BeneficiaryModel.fromMap(Map<dynamic, dynamic> map) {
    bool parseBool(dynamic val, bool defaultValue) {
      if (val == null) return defaultValue;
      if (val is bool) return val;
      final str = val.toString().toLowerCase();
      if (str == 'true' || str == '1') return true;
      if (str == 'false' || str == '0') return false;
      return defaultValue;
    }

    return BeneficiaryModel(
      name: map['name']?.toString() ?? '',
      detail: map['detail']?.toString() ?? '',
      isBank: parseBool(map['isBank'], false),
      bank: map['bank']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      BeneficiaryModel.fromMap(json);

  String toRawJson() => jsonEncode(toMap());

  factory BeneficiaryModel.fromRawJson(String source) =>
      BeneficiaryModel.fromMap(jsonDecode(source) as Map<dynamic, dynamic>);

  @override
  String toString() {
    return 'BeneficiaryModel(name: $name, detail: $detail, isBank: $isBank, bank: $bank)';
  }
}
