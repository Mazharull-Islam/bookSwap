// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockedUser _$BlockedUserFromJson(Map<String, dynamic> json) => _BlockedUser(
  id: json['id'] as String,
  blockerId: json['blockerId'] as String,
  blockedId: json['blockedId'] as String,
  blockedName: json['blockedName'] as String,
  createdAtMs: (json['createdAtMs'] as num).toInt(),
);

Map<String, dynamic> _$BlockedUserToJson(_BlockedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'blockerId': instance.blockerId,
      'blockedId': instance.blockedId,
      'blockedName': instance.blockedName,
      'createdAtMs': instance.createdAtMs,
    };
