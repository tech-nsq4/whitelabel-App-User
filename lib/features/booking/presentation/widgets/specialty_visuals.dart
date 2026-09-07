import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';

/// Icon + accent colour for a specialty tile / chip. There's no icon or
/// colour on the `GET /specializations` record, so both are derived here —
/// a keyword match on the (Arabic) title first, then a palette colour cycled
/// by list position for anything unrecognised.
class SpecialtyVisuals {
  const SpecialtyVisuals({required this.icon, required this.accent});

  final String icon;
  final ColorModel accent;

  static SpecialtyVisuals resolve(String title, int index) {
    final t = title.trim();
    final palette = AppColors.specialtyAccents;
    ColorModel cycle() => palette[index % palette.length];

    bool has(List<String> keys) => keys.any(t.contains);

    if (has(['باطن'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.stethoscope, accent: palette[0]);
    }
    if (has(['جلد'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.skin, accent: palette[1]);
    }
    if (has(['أسنان', 'اسنان', 'سن '])) {
      return SpecialtyVisuals(icon: AppSvgIcons.tooth, accent: palette[2]);
    }
    if (has(['أطفال', 'اطفال', 'طفل'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.child, accent: palette[3]);
    }
    if (has(['نسا', 'ولادة', 'حمل', 'توليد'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.womanCare, accent: palette[4]);
    }
    if (has(['عظام', 'عظم', 'مفاصل', 'كسور'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.bone, accent: palette[5]);
    }
    if (has(['عيون', 'عين', 'رمد', 'بصر'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.eye, accent: palette[6]);
    }
    if (has(['أنف', 'انف', 'أذن', 'اذن', 'حنجرة'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.ent, accent: palette[7]);
    }
    if (has(['قلب', 'أوعية', 'اوعية', 'شريان'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.heartbeat, accent: palette[1]);
    }
    if (has(['مخ', 'أعصاب', 'اعصاب', 'عصب', 'نفسي', 'نفسية'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.brain, accent: palette[5]);
    }
    if (has(['مسالك', 'كلى', 'بول'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.womanCare, accent: palette[2]);
    }
    if (has(['أشعة', 'اشعة', 'تصوير'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.xray, accent: palette[6]);
    }
    if (has(['مختبر', 'تحاليل', 'مخبر'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.flask, accent: palette[3]);
    }
    if (has(['صيدل', 'دواء', 'أدوية', 'ادوية'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.pill, accent: palette[7]);
    }
    if (has(['عام', 'أسرة', 'اسرة', 'عائلة', 'عائلية'])) {
      return SpecialtyVisuals(icon: AppSvgIcons.stethoscope, accent: palette[0]);
    }

    return SpecialtyVisuals(icon: AppSvgIcons.stethoscope, accent: cycle());
  }
}
