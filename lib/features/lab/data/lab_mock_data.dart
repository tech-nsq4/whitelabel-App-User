import 'models/clinic_report_model.dart';

class LabMockData {
  LabMockData._();

  static const Map<String, String> lastVisitByClinic = {
    'باطنة عامة': '8 يونيو',
    'جلدية': '21 مايو',
    'أسنان': 'لا تحاليل',
  };

  static const Map<String, List<ClinicReportModel>> lab = {
    'باطنة عامة': [
      ClinicReportModel(
        number: 'LAB-8841',
        date: '8 يونيو',
        doctor: 'د. خالد العتيبي',
        name: 'وظائف الغدة الدرقية',
        status: 'قيد التنفيذ',
        isReady: false,
        body: 'الحالة: العينة قيد التحليل في المختبر.\n\n'
            'ترفع النتيجة تلقائيًا فور اعتمادها من الطبيب. ستصلك إشعار.',
      ),
      ClinicReportModel(
        number: 'LAB-8102',
        date: '11 يونيو',
        doctor: 'د. خالد العتيبي',
        name: 'فيتامين د · صورة دم كاملة',
        status: 'صدرت',
        isReady: true,
        body: 'فيتامين د (25-OH): 22 ng/mL — أقل من الطبيعي (المعدل 30-100)\n\n'
            'صورة الدم الكاملة CBC: جميع المؤشرات ضمن المعدل الطبيعي.\n\n'
            'ملاحظة الطبيب: يوصف بدء مكمل فيتامين د 5000 وحدة أسبوعيًا لمدة 10 أسابيع.',
      ),
    ],
    'جلدية': [
      ClinicReportModel(
        number: 'LAB-7912',
        date: '21 مايو',
        doctor: 'د. ريم الدوسري',
        name: 'مزرعة جلدية',
        status: 'صدرت',
        isReady: true,
        body: 'النتيجة: لم يعزل أي فطر بكتيري ممرض.\n\n'
            'التشخيص المرجّح: أكزيما تماسية (غير معدية).',
      ),
    ],
  };

  static const Map<String, List<ClinicReportModel>> xray = {
    'باطنة عامة': [
      ClinicReportModel(
        number: 'RAD-4471',
        date: '8 يونيو',
        doctor: 'د. خالد العتيبي',
        name: 'أشعة سينية — الناحية الأيسر',
        status: 'قيد التنفيذ',
        isReady: false,
        body: 'الحالة: التصوير تم، والتقرير قيد المراجعة من أخصائي الأشعة.',
      ),
      ClinicReportModel(
        number: 'RAD-4120',
        date: '11 يونيو',
        doctor: 'د. خالد العتيبي',
        name: 'أشعة صدر — أمامية خلفية',
        status: 'صادر',
        isReady: true,
        body: 'الرئتان: حقلا الرئة سليمان، لا ترشحات أو تكثفات.\n\n'
            'القلب: حجم طبيعي.\n\nالخلاصة: أشعة صدر ضمن الحدود الطبيعية.',
      ),
    ],
    'عظام': [
      ClinicReportModel(
        number: 'RAD-3388',
        date: '3 أبريل',
        doctor: 'د. ماجد الشهري',
        name: 'أشعة — العمود الفقري القطني',
        status: 'صادر',
        isReady: true,
        body: 'ارتفاع أجسام الفقرات محفوظ، ضيق بسيط في مسافة L4-L5.\n\n'
            'الخلاصة: تغيرات تنكسية مبكرة في L4-L5.',
      ),
    ],
  };
}
