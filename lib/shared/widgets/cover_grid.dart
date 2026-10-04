import 'package:flutter/material.dart';

/// The grid every book-cover screen uses, so tiles are the same size
/// everywhere and fill whatever width is available.
const coverGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 180,
  childAspectRatio: 0.62,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
);
