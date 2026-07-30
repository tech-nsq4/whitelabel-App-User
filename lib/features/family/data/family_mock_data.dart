import 'models/family_member_model.dart';

class FamilyMockData {
  FamilyMockData._();

  static const members = [
    FamilyMemberModel(
      id: 'me',
      name: 'أسرة العتيبي',
      relation: 'صاحبة الحساب · 32 سنة',
      letter: 'أ',
      isActive: true,
      statusLabel: 'موعد غدًا 10:30 ص',
      visitCount: 6,
    ),
    FamilyMemberModel(
      id: 'abdullah',
      name: 'عبدالله العتيبي',
      relation: 'الزوج · 36 سنة',
      letter: 'ع',
      isActive: false,
      statusLabel: 'مرتبط بحسابك',
      visitCount: 3,
    ),
    FamilyMemberModel(
      id: 'nawaf',
      name: 'نوف عبدالله',
      relation: 'ابنتك · 7 سنوات',
      letter: 'ن',
      isActive: false,
      statusLabel: 'تطعيم مستحق خلال 20 يوم',
      visitCount: 4,
      hasVaccineDue: true,
    ),
    FamilyMemberModel(
      id: 'saud',
      name: 'سعود عبدالله',
      relation: 'ابنك · 4 سنوات',
      letter: 'س',
      isActive: false,
      statusLabel: 'كشف أطفال الخميس',
      visitCount: 1,
    ),
  ];
}
