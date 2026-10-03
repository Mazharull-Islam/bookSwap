/// Strips spaces and hyphens and upper-cases a trailing "x"; null when what's
/// left can't be an ISBN at all.
String? cleanIsbn(String? input) {
  if (input == null) return null;
  final value = input.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  return RegExp(r'^(\d{9}[\dX]|\d{13})$').hasMatch(value) ? value : null;
}

bool _validIsbn10(String v) {
  var sum = 0;
  for (var i = 0; i < 10; i++) {
    final c = v[i];
    final digit = c == 'X' ? 10 : int.parse(c);
    if (c == 'X' && i != 9) return false;
    sum += digit * (10 - i);
  }
  return sum % 11 == 0;
}

bool _validIsbn13(String v) {
  if (!(v.startsWith('978') || v.startsWith('979'))) return false;
  var sum = 0;
  for (var i = 0; i < 13; i++) {
    sum += int.parse(v[i]) * (i.isEven ? 1 : 3);
  }
  return sum % 10 == 0;
}

/// The canonical ISBN-13 for [input] (hyphens/spaces allowed, ISBN-10
/// accepted and converted), or null when it isn't a valid book ISBN — which
/// also rejects ordinary product barcodes that happen to be 13 digits.
String? toIsbn13(String? input) {
  final value = cleanIsbn(input);
  if (value == null) return null;
  if (value.length == 13) return _validIsbn13(value) ? value : null;
  if (!_validIsbn10(value)) return null;
  final body = '978${value.substring(0, 9)}';
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    sum += int.parse(body[i]) * (i.isEven ? 1 : 3);
  }
  return '$body${(10 - sum % 10) % 10}';
}
