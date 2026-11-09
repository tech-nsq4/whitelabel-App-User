import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../location_picker/data/models/picked_location.dart';
import '../../data/models/home_visit_address.dart';
import '../../data/models/home_visit_area_model.dart';
import 'home_visit_location_card.dart';

Future<HomeVisitAddress?> showHomeVisitAddressSheet(
  BuildContext context, {
  HomeVisitAreaModel? area,
  HomeVisitAddress? initialAddress,
}) {
  return showModalBottomSheet<HomeVisitAddress>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => HomeVisitAddressSheet(area: area, initialAddress: initialAddress),
  );
}

class HomeVisitAddressSheet extends StatefulWidget {
  const HomeVisitAddressSheet({super.key, this.area, this.initialAddress});

  final HomeVisitAreaModel? area;
  final HomeVisitAddress? initialAddress;

  @override
  State<HomeVisitAddressSheet> createState() => _HomeVisitAddressSheetState();
}

class _HomeVisitAddressSheetState extends State<HomeVisitAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _detailsController = TextEditingController(text: widget.initialAddress?.notes);
  late PickedLocation? _location = _initialLocation();
  bool _showLocationError = false;

  PickedLocation? _initialLocation() {
    final initial = widget.initialAddress;
    if (initial == null || !initial.hasLocation) return null;
    return PickedLocation(lat: initial.lat!, lng: initial.lng!, address: initial.address);
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final picked = await Navigator.of(context).pushNamed(
      Routes.locationPicker,
      arguments: {'initialLocation': _location},
    );
    if (!mounted || picked is! PickedLocation) return;
    setState(() {
      _location = picked;
      _showLocationError = false;
    });
  }

  void _confirm() {
    final location = _location;
    final detailsValid = _formKey.currentState?.validate() ?? false;
    if (location == null) {
      setState(() => _showLocationError = true);
      return;
    }
    if (!detailsValid) return;
    Navigator.of(context).pop(
      HomeVisitAddress(
        address: location.displayAddress,
        notes: _detailsController.text.trim(),
        lat: location.lat,
        lng: location.lng,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final areaName = widget.area?.name;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    LocaleKeys.homeVisit_addressTitle.tr(),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  6.height,
                  AppText(
                    LocaleKeys.homeVisit_addressSubtitle.tr(),
                    fontSize: 13.sp,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                  if (areaName != null && areaName.isNotEmpty) ...[
                    12.height,
                    Row(
                      children: [
                        AppSvgIcon(AppSvgIcons.home2, size: 18.r, color: primary),
                        6.width,
                        Expanded(
                          child: AppText(
                            '${LocaleKeys.homeVisit_area.tr()}: $areaName',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                  16.height,
                  HomeVisitLocationCard(
                    location: _location,
                    showError: _showLocationError,
                    onTap: _pickLocation,
                  ),
                  14.height,
                  AppText(
                    LocaleKeys.homeVisit_addressDetails.tr(),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  8.height,
                  CustomTextField(
                    hint: LocaleKeys.homeVisit_addressDetailsHint.tr(),
                    controller: _detailsController,
                    keyboardType: TextInputType.streetAddress,
                    minLines: 2,
                    maxLines: 3,
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? LocaleKeys.homeVisit_addressDetailsRequired.tr()
                        : null,
                  ),
                  20.height,
                  CustomButton(
                    onTap: _confirm,
                    title: LocaleKeys.homeVisit_confirmAddress.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
