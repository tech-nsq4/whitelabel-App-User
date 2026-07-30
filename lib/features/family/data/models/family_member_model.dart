class FamilyMemberModel {
  const FamilyMemberModel({
    required this.id,
    required this.name,
    required this.relation,
    required this.letter,
    required this.isActive,
    required this.statusLabel,
    this.bloodType = 'O+',
    this.visitCount = 0,
    this.hasVaccineDue = false,
  });

  final String id;
  final String name;
  final String relation;
  final String letter;
  final bool isActive;
  final String statusLabel;
  final String bloodType;
  final int visitCount;
  final bool hasVaccineDue;
}
