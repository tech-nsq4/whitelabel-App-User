class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.branch,
    required this.avatarLetter,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.isAvailableNow,
    required this.nextSlotLabel,
    required this.bio,
    required this.conditions,
    required this.telemedPrice,
  });

  final String id;
  final String name;
  final String specialty;
  final String branch;
  final String avatarLetter;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final bool isAvailableNow;
  final String nextSlotLabel;
  final String bio;
  final List<String> conditions;
  final int telemedPrice;
}
