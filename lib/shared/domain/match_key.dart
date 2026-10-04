/// The key that identifies "the same book" across editions and owners: its
/// Open Library work key when it has one, otherwise a normalised title|author.
/// Discovery grouping, wishlists, reading lists, reviews and Book of the Month
/// all match books with this, so they always agree.
String workMatchKey({
  required String? workKey,
  required String title,
  required String author,
}) {
  if (workKey != null && workKey.isNotEmpty) return workKey;
  return '${title.trim().toLowerCase()}|${author.trim().toLowerCase()}';
}
