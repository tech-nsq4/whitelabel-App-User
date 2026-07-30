import 'models/prescription_model.dart';

class PharmacyMockData {
  PharmacyMockData._();

  static const Map<String, List<PrescriptionModel>> byClinic = {
    'باطنة عامة': [
      PrescriptionModel(
        number: 'RX-4471',
        date: '8 يونيو',
        doctor: 'د. خالد العتيبي',
        status: 'سارية',
        isActive: true,
        medications: [
          'أموكسيسيلين 500 ملجم — كبسولة 3 مرات يوميًا · 7 أيام',
          'باراسيتامول 500 ملجم — عند الحاجة',
        ],
        refillable: true,
      ),
      PrescriptionModel(
        number: 'RX-4102',
        date: '11 يونيو',
        doctor: 'د. خالد العتيبي',
        status: 'سارية',
        isActive: true,
        medications: ['فيتامين د 5000 وحدة — مرة أسبوعيًا · 10 أسابيع'],
        refillable: true,
      ),
      PrescriptionModel(
        number: 'RX-3890',
        date: '18 يناير',
        doctor: 'د. خالد العتيبي',
        status: 'منتهية',
        isActive: false,
        medications: ['أوميبرازول 20 ملجم — كبسولة يوميًا · 14 يومًا'],
        refillable: false,
      ),
    ],
    'جلدية': [
      PrescriptionModel(
        number: 'RX-3912',
        date: '21 مايو',
        doctor: 'د. ريم الدوسري',
        status: 'منتهية',
        isActive: false,
        medications: ['هيدروكورتيزون 1٪ — كريم موضعي مرتين يوميًا · 10 أيام'],
        refillable: false,
      ),
    ],
    'أسنان': [
      PrescriptionModel(
        number: 'RX-3401',
        date: '14 فبراير',
        doctor: 'د. سارة المحطاني',
        status: 'منتهية',
        isActive: false,
        medications: [
          'كلورهيكسيدين — غسول فم مرتين يوميًا · 7 أيام',
          'آيبوبروفين 400 ملجم — عند الألم',
        ],
        refillable: false,
      ),
    ],
  };
}
