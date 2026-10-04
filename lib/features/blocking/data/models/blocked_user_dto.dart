import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/blocked_user.dart';

part 'blocked_user_dto.freezed.dart';
part 'blocked_user_dto.g.dart';

@freezed
abstract class BlockedUserDto with _$BlockedUserDto {
  const BlockedUserDto._();

  const factory BlockedUserDto({
    required String id,
    required String blockerId,
    required String blockedId,
    required String blockedName,
    required int createdAtMs,
  }) = _BlockedUserDto;

  factory BlockedUserDto.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserDtoFromJson(json);

  factory BlockedUserDto.fromEntity(BlockedUser entity) => BlockedUserDto(
    id: entity.id,
    blockerId: entity.blockerId,
    blockedId: entity.blockedId,
    blockedName: entity.blockedName,
    createdAtMs: entity.createdAtMs,
  );

  BlockedUser toEntity() => BlockedUser(
    id: id,
    blockerId: blockerId,
    blockedId: blockedId,
    blockedName: blockedName,
    createdAtMs: createdAtMs,
  );

  static BlockedUser parse(Map<String, dynamic> json) =>
      BlockedUserDto.fromJson(json).toEntity();
}

extension BlockedUserJson on BlockedUser {
  Map<String, dynamic> toJson() => BlockedUserDto.fromEntity(this).toJson();
}
