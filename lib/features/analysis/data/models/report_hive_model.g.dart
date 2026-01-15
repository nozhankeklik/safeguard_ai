// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportHiveModelAdapter extends TypeAdapter<ReportHiveModel> {
  @override
  final int typeId = 0;

  @override
  ReportHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportHiveModel(
      id: fields[0] as String,
      analysis: fields[1] as String,
      riskLevel: fields[2] as String,
      imagePath: fields[3] as String,
      timestamp: fields[4] as DateTime,
      emailSubject: fields[5] as String,
      emailBody: fields[6] as String,
      recipients: (fields[7] as List).cast<String>(),
      ccRecipients: (fields[8] as List).cast<String>(),
      emailSent: fields[9] as bool,
      savedToGoogleDrive: fields[10] as bool,
      pdfGenerated: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ReportHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.analysis)
      ..writeByte(2)
      ..write(obj.riskLevel)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.emailSubject)
      ..writeByte(6)
      ..write(obj.emailBody)
      ..writeByte(7)
      ..write(obj.recipients)
      ..writeByte(8)
      ..write(obj.ccRecipients)
      ..writeByte(9)
      ..write(obj.emailSent)
      ..writeByte(10)
      ..write(obj.savedToGoogleDrive)
      ..writeByte(11)
      ..write(obj.pdfGenerated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
