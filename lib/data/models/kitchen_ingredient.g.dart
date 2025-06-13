// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_ingredient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KitchenIngredientAdapter extends TypeAdapter<KitchenIngredient> {
  @override
  final int typeId = 1;

  @override
  KitchenIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KitchenIngredient(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KitchenIngredient obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KitchenIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
