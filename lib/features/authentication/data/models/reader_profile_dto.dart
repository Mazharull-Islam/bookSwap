import '../../domain/entities/registration.dart';

/// How a [ReaderProfile] is stored in the `profiles` Firestore document.
/// (Older documents also carry `acceptedTerms*` fields; they are ignored.)
abstract final class ReaderProfileDto {
  static ReaderProfile parse(Map<String, dynamic> data) => ReaderProfile.stored(
    firstName: data['firstName'] as String,
    lastName: data['lastName'] as String,
    gender: data['gender'] as String,
    mobile: data['mobile'] as String,
    address: data['address'] as String,
    preferences: List<String>.from(data['preferences'] as List),
    favoriteBook: data['favoriteBook'] as String,
    maxDistanceKm: (data['maxDistanceKm'] as num?)?.toDouble(),
  );
}

extension ReaderProfileMap on ReaderProfile {
  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'gender': gender,
    'mobile': mobile,
    'address': address,
    'preferences': preferences,
    'favoriteBook': favoriteBook,
    'maxDistanceKm': maxDistanceKm,
  };
}

/// The fields a profile edit writes, trimmed.
extension ProfileUpdateMap on ProfileUpdate {
  Map<String, dynamic> toMap() => {
    'firstName': firstName.trim(),
    'lastName': lastName.trim(),
    'gender': gender,
    'mobile': mobile.trim(),
    'address': address.trim(),
    'preferences': preferences,
    'favoriteBook': favoriteBook.trim(),
  };
}
