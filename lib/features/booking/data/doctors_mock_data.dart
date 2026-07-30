import 'models/doctor_model.dart';

class DoctorsMockData {
  DoctorsMockData._();

  static const specialties = [
    'باطنة عامة',
    'جلدية',
    'أسنان',
    'أطفال',
    'نساء وولادة',
  ];

  static const Map<String, List<DoctorModel>> bySpecialty = {
    'باطنة عامة': [
      DoctorModel(
        id: 'doc-khaled',
        name: 'د. خالد العتيبي',
        specialty: 'استشاري باطنة',
        branch: 'فرع العلا',
        avatarLetter: 'خ',
        rating: 4.9,
        reviewCount: 412,
        experienceYears: 18,
        isAvailableNow: true,
        nextSlotLabel: 'اليوم 4:30 م',
        bio: 'استشاري الباطنة العامة والجهاز الهضمي. خريج كلية الطب بجامعة الملك '
            'سعود، والزمالة السعودية في الباطنة، مع زمالة دقيقة في أمراض الجهاز '
            'الهضمي والكبد.',
        conditions: [
          'اضطرابات الجهاز الهضمي',
          'ارتجاع المريء',
          'القولون العصبي',
          'السكري',
          'ضغط الدم',
          'فحوصات دورية',
        ],
        telemedPrice: 100,
      ),
      DoctorModel(
        id: 'doc-majed',
        name: 'د. ماجد الغامدي',
        specialty: 'أخصائي باطنة',
        branch: 'فرع العلا',
        avatarLetter: 'م',
        rating: 4.7,
        reviewCount: 188,
        experienceYears: 9,
        isAvailableNow: true,
        nextSlotLabel: 'غدًا 10:00 ص',
        bio: 'أخصائي باطنة عامة، مهتم بأمراض الغدد الصماء والسكري.',
        conditions: ['السكري', 'الغدة الدرقية', 'السمنة'],
        telemedPrice: 80,
      ),
    ],
    'جلدية': [
      DoctorModel(
        id: 'doc-reem',
        name: 'د. ريم الدوسري',
        specialty: 'استشارية جلدية',
        branch: 'فرع المرجس',
        avatarLetter: 'ر',
        rating: 4.9,
        reviewCount: 356,
        experienceYears: 14,
        isAvailableNow: false,
        nextSlotLabel: 'الخميس 6:00 م',
        bio: 'استشارية الأمراض الجلدية والتجميل، مهتمة بحالات الأكزيما والصدفية.',
        conditions: ['الأكزيما', 'حب الشباب', 'الصدفية', 'تساقط الشعر'],
        telemedPrice: 100,
      ),
    ],
  };

  static DoctorModel? byId(String id) {
    for (final list in bySpecialty.values) {
      for (final d in list) {
        if (d.id == id) return d;
      }
    }
    return null;
  }
}
