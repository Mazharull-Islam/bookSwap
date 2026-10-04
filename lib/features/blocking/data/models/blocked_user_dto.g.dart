// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockedUserDto _$BlockedUserDtoFromJson(Map<String, dynamic> json) =>
    _BlockedUserDto(
      id: json['id'] as String,
      blockerId: json['blockerId'] as String,
      blockedId: json['blockedId'] as String,
      blockedName: json['blockedName'] as String,
      createdAtMs: (json['createdAtMs'] as num).toInt(),
    );

Map<String, dynamic> _$BlockedUserDtoToJson(_BlockedUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'blockerId': instance.blockerId,
      'blockedId': instance.blockedId,
      'blockedName': instance.blockedName,
      'createdAtMs': instance.createdAtMs,
    };
