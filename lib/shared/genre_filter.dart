/// The standard genres offered as filter chips. Stored book/reading genres
/// are free-form subject strings from Open Library ("Fantasy fiction",
/// "Detective and mystery stories"…), so each standard genre matches by
/// keyword rather than exact text.
const filterGenres = [
  'Action',
  'Adventure',
  'Biography',
  'Comedy',
  'Crime',
  'Drama',
  'Fantasy',
  'Historical',
  'Horror',
  'Mystery',
  'Poetry',
  'Romance',
  'Science fiction',
  'Thriller',
];

const _genreKeywords = <String, List<String>>{
  'Action': ['action'],
  'Adventure': ['adventure'],
  'Biography': ['biograph', 'memoir'],
  'Comedy': ['comedy', 'humor', 'humour', 'satire'],
  'Crime': ['crime', 'detective', 'murder'],
  'Drama': ['drama'],
  'Fantasy': ['fantasy'],
  'Historical': ['historical', 'history'],
  'Horror': ['horror', 'ghost'],
  'Mystery': ['mystery', 'detective'],
  'Poetry': ['poetry', 'poems'],
  'Romance': ['romance', 'love stories'],
  'Science fiction': ['science fiction', 'sci-fi', 'scifi'],
  'Thriller': ['thriller', 'suspense'],
};

/// True when nothing is selected, or [genreText] matches at least one of the
/// [selected] standard genres.
bool genreMatchesAny(String genreText, Set<String> selected) {
  if (selected.isEmpty) return true;
  final text = genreText.toLowerCase();
  return selected.any(
    (genre) =>
        (_genreKeywords[genre] ?? [genre.toLowerCase()]).any(text.contains),
  );
}
