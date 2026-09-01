import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class BeneficiaryModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String detail;

  @HiveField(2)
  final bool isBank;

  @HiveField(3)
  final String? bank;

  BeneficiaryModel({
    required this.name,
    required this.detail,
    required this.isBank,
    this.bank,
  });

  Map<String, String> toMap() {
    final map = <String, String>{
      'name': name,
      'detail': detail,
    };
    if (bank != null) {
      map['bank'] = bank!;
    }
    return map;
  }
}

class BeneficiaryModelAdapter extends TypeAdapter<BeneficiaryModel> {
  @override
  final int typeId = 3;

  @override
  BeneficiaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BeneficiaryModel(
      name: fields[0] as String? ?? '',
      detail: fields[1] as String? ?? '',
      isBank: fields[2] as bool? ?? false,
      bank: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BeneficiaryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.detail)
      ..writeByte(2)
      ..write(obj.isBank)
      ..writeByte(3)
      ..write(obj.bank);
  }
}
