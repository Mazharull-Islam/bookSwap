import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the layering every feature follows:
///
///   presentation -> application -> domain <- data
///
/// * domain: entities, repository interfaces, pure rules. Plain Dart: knows
///   nothing about Flutter, Firebase, Hive, JSON or any other layer.
/// * application: use cases. Talks to the domain only.
/// * data: DTOs (freezed/json), mappers and repository implementations. The
///   only place that knows how things are stored. May use the domain, never
///   the UI.
/// * presentation: widgets and providers. Providers are the composition root
///   and are the only presentation files allowed to construct data classes.
void main() {
  final libDir = Directory('lib');

  final imports = <String, List<String>>{};
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final path = entity.path.replaceAll('\\', '/');
    if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) continue;
    imports[path] = RegExp(
      r'''^(?:import|export)\s+['"]([^'"]+)['"]''',
      multiLine: true,
    ).allMatches(entity.readAsStringSync()).map((m) => m.group(1)!).toList();
  }

  /// Resolves an import written relative to [from] to a lib/-relative path.
  String resolve(String from, String import) {
    if (import.startsWith('package:bookswap_login/')) {
      return 'lib/${import.substring('package:bookswap_login/'.length)}';
    }
    if (import.startsWith('package:') || import.startsWith('dart:')) {
      return import;
    }
    final parts = from.split('/')..removeLast();
    for (final segment in import.split('/')) {
      if (segment == '..') {
        parts.removeLast();
      } else if (segment != '.') {
        parts.add(segment);
      }
    }
    return parts.join('/');
  }

  bool inLayer(String path, String layer) =>
      RegExp('^lib/features/[^/]+/$layer/').hasMatch(path);

  List<String> violations({
    required bool Function(String file) appliesTo,
    required bool Function(String target) forbidden,
  }) => [
    for (final entry in imports.entries)
      if (appliesTo(entry.key))
        for (final import in entry.value)
          if (forbidden(resolve(entry.key, import)))
            '${entry.key} imports $import',
  ];

  const storageAndUi = [
    'package:flutter/',
    'package:flutter_riverpod/',
    'package:cloud_firestore/',
    'package:firebase_',
    'package:hive',
    'package:dio/',
    'package:freezed_annotation/',
    'package:json_annotation/',
    'package:go_router/',
    'package:image_picker/',
    'package:geolocator/',
    'package:google_sign_in/',
    'package:mobile_scanner/',
    'package:cached_network_image/',
    'package:flutter_local_notifications/',
  ];

  bool isStorageOrUi(String target) => storageAndUi.any(target.startsWith);

  bool inAnyFeatureLayer(String target, String layer) =>
      RegExp('^lib/features/[^/]+/$layer/').hasMatch(target);

  test('the domain layer is plain Dart', () {
    final bad = violations(
      appliesTo: (f) => inLayer(f, 'domain'),
      forbidden: (t) =>
          isStorageOrUi(t) ||
          inAnyFeatureLayer(t, 'data') ||
          inAnyFeatureLayer(t, 'presentation') ||
          inAnyFeatureLayer(t, 'application') ||
          t.startsWith('lib/core/services/') ||
          t.startsWith('lib/app/'),
    );
    expect(
      bad,
      isEmpty,
      reason:
          'domain must not depend on Flutter, storage, or other layers:\n'
          '${bad.join('\n')}',
    );
  });

  test('the application layer only depends on the domain', () {
    final bad = violations(
      appliesTo: (f) => inLayer(f, 'application'),
      forbidden: (t) =>
          isStorageOrUi(t) ||
          inAnyFeatureLayer(t, 'data') ||
          inAnyFeatureLayer(t, 'presentation') ||
          t.startsWith('lib/core/services/') ||
          t.startsWith('lib/app/'),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('the data layer never reaches into the UI', () {
    final bad = violations(
      appliesTo: (f) => inLayer(f, 'data'),
      forbidden: (t) =>
          t.startsWith('package:flutter/material.dart') ||
          t.startsWith('package:flutter/widgets.dart') ||
          t.startsWith('package:flutter_riverpod/') ||
          t.startsWith('package:go_router/') ||
          inAnyFeatureLayer(t, 'presentation') ||
          t.startsWith('lib/app/'),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('widgets never construct data classes directly', () {
    // Providers are the composition root: they wire a repository implementation
    // to its interface. Everything else in presentation talks to providers.
    final bad = violations(
      appliesTo: (f) =>
          inLayer(f, 'presentation') && !f.contains('/presentation/providers/'),
      forbidden: (t) => inAnyFeatureLayer(t, 'data'),
    );
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('every freezed DTO lives in a data layer, not in the domain', () {
    final stray = [
      for (final f in Directory('lib').listSync(recursive: true))
        if (f is File &&
            (f.path.endsWith('.freezed.dart') || f.path.endsWith('.g.dart')) &&
            !f.path.replaceAll('\\', '/').contains('/data/'))
          f.path,
    ];
    expect(stray, isEmpty, reason: 'generated code belongs in data/: $stray');
  });

  test(
    'no domain/models folders remain (entities live in domain/entities)',
    () {
      final leftovers = [
        for (final d in libDir.listSync(recursive: true))
          if (d is Directory &&
              RegExp(
                r'lib/features/[^/]+/domain/models$',
              ).hasMatch(d.path.replaceAll('\\', '/')))
            d.path,
      ];
      expect(leftovers, isEmpty);
    },
  );
}
