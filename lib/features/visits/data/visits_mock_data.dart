import '../../../core/utils/app_svg_icons.dart';
import 'models/visit_models.dart';

/// Static mock data mirroring the reference design's VISIT_DATA — used until
/// a real visits API is wired up.
class VisitsMockData {
  VisitsMockData._();

  static final clinics = [
    ClinicSummary(
      name: 'باطنة عامة',
      icon: AppSvgIcons.stethoscope,
      lastVisitLabel: 'آخر زيارة: 8 يونيو',
      count: 6,
    ),
    ClinicSummary(
      name: 'جلدية',
      icon: AppSvgIcons.stethoscope,
      lastVisitLabel: 'آخر زيارة: 21 مايو',
      count: 4,
    ),
    ClinicSummary(
      name: 'أسنان',
      icon: AppSvgIcons.stethoscope,
      lastVisitLabel: 'آخر زيارة: 14 فبراير',
      count: 3,
    ),
    ClinicSummary(
      name: 'أطفال',
      icon: AppSvgIcons.stethoscope,
      lastVisitLabel: 'آخر زيارة: 9 يناير',
      count: 1,
    ),
  ];

  static final Map<String, List<VisitModel>> byClinic = {
    'باطنة عامة': [
      VisitModel(
        id: 'V-1180',
        date: 'الاثنين 8 يونيو',
        doctor: 'د. خالد العتيبي',
        branch: 'فرع العلا',
        type: 'كشف باطنة',
        status: 'مكتملة',
        diagnosis:
            'التهاب لوزتين حاد مع ارتفاع في الحرارة (38.4°). لا علامات مضاعفات.',
        items: [
          VisitItemModel(
            icon: AppSvgIcons.pill,
            title: 'وصفة دوائية',
            subtitle: 'أموكسيسيلين 500 · باراسيتامول 500',
            status: 'سارية',
          ),
          VisitItemModel(
            icon: AppSvgIcons.flask,
            title: 'تحليل — وظائف الغدة TSH',
            subtitle: 'طُلب في هذه الزيارة',
            status: 'قيد التنفيذ',
            statusKind: VisitItemStatus.pending,
          ),
          VisitItemModel(
            icon: AppSvgIcons.xray,
            title: 'أشعة — الناحية الأيسر',
            subtitle: 'طُلب في هذه الزيارة',
            status: 'قيد التنفيذ',
            statusKind: VisitItemStatus.pending,
          ),
        ],
      ),
      VisitModel(
        id: 'V-1156',
        date: 'الأربعاء 11 يونيو',
        doctor: 'د. خالد العتيبي',
        branch: 'فرع العلا',
        type: 'متابعة',
        status: 'مكتملة',
        diagnosis: 'نقص فيتامين د (22 ng/mL). صورة الدم ضمن المعدل الطبيعي.',
        items: [
          VisitItemModel(
            icon: AppSvgIcons.flask,
            title: 'تحاليل — فيتامين د · CBC',
            subtitle: 'صدرت النتيجة',
            status: 'صدرت',
          ),
        ],
      ),
    ],
    'جلدية': [
      VisitModel(
        id: 'V-1102',
        date: 'السبت 21 مايو',
        doctor: 'د. ريم الدوسري',
        branch: 'فرع المرجس',
        type: 'كشف جلدية',
        status: 'مكتملة',
        diagnosis: 'أكزيما تماسية في اليدين. غير معدية.',
        items: [
          VisitItemModel(
            icon: AppSvgIcons.pill,
            title: 'وصفة موضعية',
            subtitle: 'هيدروكورتيزون 1٪',
            status: 'مكتملة',
          ),
        ],
      ),
    ],
    'أسنان': [
      VisitModel(
        id: 'V-0955',
        date: 'الجمعة 14 فبراير',
        doctor: 'د. سارة المحطاني',
        branch: 'فرع العلا',
        type: 'كشف أسنان',
        status: 'مكتملة',
        diagnosis: 'التهاب لثة بسيط. ينصح بتنظيف دوري.',
        items: const [],
      ),
    ],
    'أطفال': [
      VisitModel(
        id: 'V-0870',
        date: 'الخميس 9 يناير',
        doctor: 'د. ماجد الشهري',
        branch: 'فرع الماسين',
        type: 'كشف أطفال',
        status: 'مكتملة',
        diagnosis: 'فحص نمو دوري — ضمن المعدل الطبيعي للعمر.',
        items: const [],
      ),
    ],
  };
}
