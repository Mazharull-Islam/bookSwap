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

/// Lower-case stems that signal each standard genre. Matched at the start of
/// a word, so 'biograph' covers biography/biographies but 'alien' wouldn't
/// be used (it would also hit "alienation").
const genreKeywords = <String, List<String>>{
  'Action': ['action'],
  'Adventure': ['adventure', 'quest', 'survival'],
  'Biography': ['biograph', 'memoir', 'autobiograph'],
  'Comedy': ['comedy', 'humor', 'humour', 'satire'],
  'Crime': ['crime', 'detective', 'murder', 'noir', 'police procedural'],
  'Drama': ['drama'],
  'Fantasy': ['fantasy', 'wizard', 'dragon', 'elves', 'magic'],
  'Historical': ['historical', 'history'],
  'Horror': ['horror', 'ghost', 'haunted', 'supernatural', 'vampire', 'zombie'],
  'Mystery': ['mystery', 'mysteries', 'detective', 'whodunit'],
  'Poetry': ['poetry', 'poems', 'poet'],
  'Romance': ['romance', 'love stories', 'love story', 'romantic'],
  'Science fiction': [
    'science fiction',
    'sci-fi',
    'scifi',
    'space opera',
    'dystopi',
    'cyberpunk',
    'time travel',
  ],
  'Thriller': ['thriller', 'suspense', 'espionage', 'spy', 'conspiracy'],
};

/// True when nothing is selected, or [genreText] matches at least one of the
/// [selected] standard genres.
bool genreMatchesAny(String genreText, Set<String> selected) {
  if (selected.isEmpty) return true;
  final text = genreText.toLowerCase();
  return selected.any(
    (genre) =>
        (genreKeywords[genre] ?? [genre.toLowerCase()]).any(text.contains),
  );
}
