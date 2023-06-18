// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      iconData: json['iconData'] as int,
      position: json['position'] as int,
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconData': instance.iconData,
      'position': instance.position,
    };
