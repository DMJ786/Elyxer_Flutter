/// Gender Identity Models
/// Sub-options for each gender category
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gender_identity_models.freezed.dart';

/// A specific gender identity option within a gender category
@freezed
abstract class GenderIdentityOption with _$GenderIdentityOption {
  const factory GenderIdentityOption({
    required String id,
    required String label,
  }) = _GenderIdentityOption;
}

/// Centralized gender identity options per gender
class GenderIdentityOptions {
  GenderIdentityOptions._();

  static const List<GenderIdentityOption> man = [
    GenderIdentityOption(id: 'man', label: 'Man'),
    GenderIdentityOption(id: 'cisgender_man', label: 'Cis man'),
    GenderIdentityOption(id: 'intersex_man', label: 'Intersex Man'),
    GenderIdentityOption(id: 'transgender_man', label: 'Trans man'),
    GenderIdentityOption(id: 'transmasculine', label: 'Transmasculine'),
    GenderIdentityOption(id: 'man_and_nonbinary', label: 'Man & Nonbinary'),
  ];

  static const List<GenderIdentityOption> woman = [
    GenderIdentityOption(id: 'woman', label: 'Woman'),
    GenderIdentityOption(id: 'cisgender_woman', label: 'Cis woman'),
    GenderIdentityOption(id: 'intersex_woman', label: 'Intersex Woman'),
    GenderIdentityOption(id: 'transgender_woman', label: 'Trans woman'),
    GenderIdentityOption(id: 'transfeminine', label: 'Transfeminine'),
    GenderIdentityOption(id: 'woman_and_nonbinary', label: 'Woman & Nonbinary'),
  ];

  static const List<GenderIdentityOption> nonBinary = [
    GenderIdentityOption(id: 'agender', label: 'Agender'),
    GenderIdentityOption(id: 'bigender', label: 'Bigender'),
    GenderIdentityOption(id: 'genderfluid', label: 'Genderfluid'),
    GenderIdentityOption(id: 'genderqueer', label: 'Genderqueer'),
    GenderIdentityOption(id: 'gender_nonconfirming', label: 'Gender nonconfirming'),
    GenderIdentityOption(id: 'gender_questioning', label: 'Gender questioning'),
    GenderIdentityOption(id: 'gender_variant', label: 'Gender variant'),
    GenderIdentityOption(id: 'intersex', label: 'Intersex'),
    GenderIdentityOption(id: 'neutrois', label: 'Neutrois'),
    GenderIdentityOption(id: 'nonbinary_man', label: 'Nonbinary man'),
    GenderIdentityOption(id: 'pangender', label: 'Pangender'),
    GenderIdentityOption(id: 'polygender', label: 'Polygender'),
    GenderIdentityOption(id: 'transgender', label: 'Transgender'),
    GenderIdentityOption(id: 'two_spirit', label: 'Two-Spirit'),
  ];
}
