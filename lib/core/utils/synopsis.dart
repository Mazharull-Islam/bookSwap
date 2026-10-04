/// A plain-text synopsis from a source that may hand back HTML (Google Books
/// descriptions contain <p>, <b>, <br> and entities). Null when what's left is
/// too short to be a real description.
String? cleanSynopsis(String? raw, {int maxLength = 2000}) {
  if (raw == null) return null;
  var text = raw
      .replaceAll(RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<\s*/\s*p\s*>', caseSensitive: false), '\n\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&');
  text = text
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
      .join('\n')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
  if (text.length < 20) return null;
  if (text.length <= maxLength) return text;
  // Cut at a word boundary rather than mid-word.
  final cut = text.substring(0, maxLength);
  final space = cut.lastIndexOf(' ');
  return '${cut.substring(0, space > maxLength ~/ 2 ? space : maxLength)}…';
}
