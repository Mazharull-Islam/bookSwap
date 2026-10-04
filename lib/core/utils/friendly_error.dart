import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

/// A sentence safe to show a member, instead of an exception's raw text.
/// Domain validation failures carry their own messages — catch those first.
String friendlyError(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is FirebaseException) {
    return switch (error.code) {
      'permission-denied' => "You don't have permission to do that.",
      'unavailable' || 'network-request-failed' || 'deadline-exceeded' =>
        "Can't reach the server. Check your connection and try again.",
      'not-found' => 'That item no longer exists.',
      _ => fallback,
    };
  }
  if (error is TimeoutException || error is SocketException) {
    return "Can't reach the server. Check your connection and try again.";
  }
  return fallback;
}
