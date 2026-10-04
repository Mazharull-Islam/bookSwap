/// Device-local log of which badges have already been announced for a member.
abstract interface class SeenBadgesRepository {
  /// False the first time a member's badges are ever computed on this device.
  bool hasBaseline(String userId);

  Set<String> getSeen(String userId);

  Future<void> setSeen(String userId, Set<String> badgeNames);
}
