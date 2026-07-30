import '../../../core/utils/app_svg_icons.dart';

/// Presentational metadata (icon + availability blurb) for a specialty tile
/// in the telemed specialty list — independent of the doctor-level mock
/// data in `DoctorsMockData`, since availability here is shown per
/// specialty rather than aggregated from individual doctors.
class TelemedSpecialtyInfo {
  const TelemedSpecialtyInfo({
    required this.name,
    required this.icon,
    required this.availabilityLabel,
  });

  final String name;
  final String icon;
  final String availabilityLabel;
}

class TelemedSpecialtyMockData {
  TelemedSpecialtyMockData._();

  static final List<TelemedSpecialtyInfo> all = [
    TelemedSpecialtyInfo(
      name: 'باطنة عامة',
      icon: AppSvgIcons.stethoscope,
      availabilityLabel: 'طبيبان متاحان الآن',
    ),
    TelemedSpecialtyInfo(
      name: 'جلدية',
      icon: AppSvgIcons.heartbeat,
      availabilityLabel: 'طبيبة متاحة الآن',
    ),
    TelemedSpecialtyInfo(
      name: 'أسنان',
      icon: AppSvgIcons.star,
      availabilityLabel: 'متاحة 6:00 م',
    ),
    TelemedSpecialtyInfo(
      name: 'أطفال',
      icon: AppSvgIcons.family,
      availabilityLabel: 'طبيب متاح الآن',
    ),
    TelemedSpecialtyInfo(
      name: 'نساء وولادة',
      icon: AppSvgIcons.shieldLock,
      availabilityLabel: 'متاحة 7:00 م',
    ),
  ];
}
