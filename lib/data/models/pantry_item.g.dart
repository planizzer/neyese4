// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PantryItemAdapter extends TypeAdapter<PantryItem> {
  @override
  final int typeId = 1;

  @override
  PantryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PantryItem(
      productName: fields[0] as String,
      brand: fields[1] as String?,
      quantity: fields[2] as double,
      unit: fields[3] as String,
      category: fields[4] as String,
      addedDate: fields[5] as DateTime,
      expirationDate: fields[6] as DateTime?,
      barcode: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PantryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.addedDate)
      ..writeByte(6)
      ..write(obj.expirationDate)
      ..writeByte(7)
      ..write(obj.barcode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PantryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
