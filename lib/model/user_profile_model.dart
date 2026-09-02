import 'dart:convert';

class UserProfileModel {
  final String name;
  final String phone;
  final String upiId;
  final String mpin;
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final bool darkModeEnabled;

  UserProfileModel({
    this.name = 'Alex',
    this.phone = '+91 98765 43210',
    this.upiId = 'alex@paynow',
    this.mpin = '1234',
    this.notificationsEnabled = true,
    this.biometricsEnabled = true,
    this.darkModeEnabled = false,
  });

  UserProfileModel copyWith({
    String? name,
    String? phone,
    String? upiId,
    String? mpin,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
    bool? darkModeEnabled,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      upiId: upiId ?? this.upiId,
      mpin: mpin ?? this.mpin,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'upiId': upiId,
      'mpin': mpin,
      'notificationsEnabled': notificationsEnabled,
      'biometricsEnabled': biometricsEnabled,
      'darkModeEnabled': darkModeEnabled,
    };
  }

  factory UserProfileModel.fromMap(Map<dynamic, dynamic> map) {
    bool parseBool(dynamic val, bool defaultValue) {
      if (val == null) return defaultValue;
      if (val is bool) return val;
      final str = val.toString().toLowerCase();
      if (str == 'true' || str == '1') return true;
      if (str == 'false' || str == '0') return false;
      return defaultValue;
    }

    return UserProfileModel(
      name: map['name']?.toString() ?? 'Alex',
      phone: map['phone']?.toString() ?? '+91 98765 43210',
      upiId: map['upiId']?.toString() ?? 'alex@paynow',
      mpin: map['mpin']?.toString() ?? '1234',
      notificationsEnabled: parseBool(map['notificationsEnabled'], true),
      biometricsEnabled: parseBool(map['biometricsEnabled'], true),
      darkModeEnabled: parseBool(map['darkModeEnabled'], false),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel.fromMap(json);

  String toRawJson() => jsonEncode(toMap());

  factory UserProfileModel.fromRawJson(String source) =>
      UserProfileModel.fromMap(jsonDecode(source) as Map<dynamic, dynamic>);

  @override
  String toString() {
    return 'UserProfileModel(name: $name, phone: $phone, upiId: $upiId, mpin: $mpin, notificationsEnabled: $notificationsEnabled, biometricsEnabled: $biometricsEnabled, darkModeEnabled: $darkModeEnabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileModel &&
        other.name == name &&
        other.phone == phone &&
        other.upiId == upiId &&
        other.mpin == mpin &&
        other.notificationsEnabled == notificationsEnabled &&
        other.biometricsEnabled == biometricsEnabled &&
        other.darkModeEnabled == darkModeEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      phone,
      upiId,
      mpin,
      notificationsEnabled,
      biometricsEnabled,
      darkModeEnabled,
    );
  }
}
