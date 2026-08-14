import 'package:flutter/material.dart';

import '../../../../core/widgets/screen_state_layout.dart';

/// Shared shell for every drill-down level on [SpecsScreen] — a scrollable
/// list, or the common "nothing here" view when it's empty.
class SpecialtyOptionsList extends StatelessWidget {
  const SpecialtyOptionsList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.padding,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const CustomNoDataView();

    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
