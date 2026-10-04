enum AchievementBadge {
  firstLoan,
  trustedBorrower,
  superLender,
  avidBorrower,
  bookworm,
}

class BadgeInfo {
  const BadgeInfo({
    required this.badge,
    required this.emoji,
    required this.label,
    required this.description,
  });

  final AchievementBadge badge;
  final String emoji;
  final String label;
  final String description;
}

const badgeCatalog = <AchievementBadge, BadgeInfo>{
  AchievementBadge.firstLoan: BadgeInfo(
    badge: AchievementBadge.firstLoan,
    emoji: '🎉',
    label: 'First Loan',
    description: 'Completed your first loan.',
  ),
  AchievementBadge.trustedBorrower: BadgeInfo(
    badge: AchievementBadge.trustedBorrower,
    emoji: '🤝',
    label: 'Trusted Borrower',
    description: '5+ loans borrowed, all returned on time.',
  ),
  AchievementBadge.superLender: BadgeInfo(
    badge: AchievementBadge.superLender,
    emoji: '📦',
    label: 'Super Lender',
    description: '10+ loans completed as a lender.',
  ),
  AchievementBadge.avidBorrower: BadgeInfo(
    badge: AchievementBadge.avidBorrower,
    emoji: '📚',
    label: 'Avid Borrower',
    description: '5+ loans completed as a borrower.',
  ),
  AchievementBadge.bookworm: BadgeInfo(
    badge: AchievementBadge.bookworm,
    emoji: '🐛',
    label: 'Bookworm',
    description: '10+ books marked Read.',
  ),
};
