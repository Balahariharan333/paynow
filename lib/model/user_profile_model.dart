import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String upiId;

  @HiveField(3)
  final String mpin;

  @HiveField(4)
  final bool notificationsEnabled;

  @HiveField(5)
  final bool biometricsEnabled;

  @HiveField(6)
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
}

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 0;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      name: fields[0] as String? ?? 'Alex',
      phone: fields[1] as String? ?? '+91 98765 43210',
      upiId: fields[2] as String? ?? 'alex@paynow',
      mpin: fields[3] as String? ?? '1234',
      notificationsEnabled: fields[4] as bool? ?? true,
      biometricsEnabled: fields[5] as bool? ?? true,
      darkModeEnabled: fields[6] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.upiId)
      ..writeByte(3)
      ..write(obj.mpin)
      ..writeByte(4)
      ..write(obj.notificationsEnabled)
      ..writeByte(5)
      ..write(obj.biometricsEnabled)
      ..writeByte(6)
      ..write(obj.darkModeEnabled);
  }
}
