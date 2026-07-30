/// Raw line-icon markup (viewBox 0 0 24 24, stroke=currentColor), copied
/// 1:1 from the reference design so icon geometry matches exactly.
/// Used with [AppSvgIcon].
class AppSvgIcons {
  AppSvgIcons._();

  static String _icon(String paths, {double strokeWidth = 1.6}) => '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="$strokeWidth" stroke-linecap="round" stroke-linejoin="round" xmlns="http://www.w3.org/2000/svg">
$paths
</svg>''';

  static final String home = _icon(
    '<path d="M3.5 10.5L12 3.5l8.5 7"/><path d="M5.5 9.5V20h13V9.5"/>',
  );

  static final String medicalFile = _icon(
    '<path d="M5 3.5h14v17l-7-3.5-7 3.5z"/><path d="M9 8h6M9 11.5h4"/>',
  );

  static final String plus = _icon(
    '<path d="M12 5.5v13M5.5 12h13"/>',
    strokeWidth: 2,
  );

  static final String family = _icon(
    '<circle cx="9" cy="8" r="3.2"/><path d="M3 20c0-3.3 2.7-5.5 6-5.5s6 2.2 6 5.5"/>'
    '<circle cx="17.5" cy="9" r="2.4"/><path d="M16 14.5c3 0 5 2 5 5"/>',
  );

  static final String account = _icon(
    '<circle cx="12" cy="8" r="3.6"/><path d="M4.5 20c0-4 3.4-6.5 7.5-6.5s7.5 2.5 7.5 6.5"/>',
  );

  static final String bell = _icon(
    '<path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 01-3.4 0"/>',
  );

  static final String card = _icon(
    '<rect x="2" y="5" width="20" height="14" rx="2.5"/><circle cx="8" cy="11" r="2"/>'
    '<path d="M4.5 16.5c.6-1.6 2-2.4 3.5-2.4s2.9.8 3.5 2.4M15 10h4M15 13.5h2.5"/>',
  );

  static final String star = _icon(
    '<path d="M12 2.5l2.6 5.3 5.9.9-4.2 4.1 1 5.8-5.3-2.8-5.3 2.8 1-5.8L3.5 8.7l5.9-.9z"/>',
  );

  static final String sparkle = _icon(
    '<path d="M12 3v3M12 18v3M5.6 5.6l2.1 2.1M16.3 16.3l2.1 2.1M3 12h3M18 12h3'
    'M5.6 18.4l2.1-2.1M16.3 7.7l2.1-2.1"/><circle cx="12" cy="12" r="3.5"/>',
  );

  /// Trailing chevron on list rows (points to the reading direction of RTL text).
  static final String chevronRow = _icon('<path d="M14.5 6l-6 6 6 6"/>');

  /// Leading back-navigation chevron used in screen headers.
  static final String chevronBack = _icon('<path d="M9.5 6l6 6-6 6"/>');

  static final String calendar = _icon(
    '<rect x="3.5" y="5" width="17" height="16" rx="2.5"/><path d="M3.5 9.5h17M8 3v3M16 3v3"/>'
    '<path d="M12 12.5v4M10 14.5h4"/>',
  );

  static final String videoCam = _icon(
    '<rect x="2.5" y="5" width="14" height="11" rx="2"/><path d="M16.5 9.5l5-3v11l-5-3z"/>',
  );

  static final String ambulance = _icon(
    '<path d="M2.5 16v-4.5l2.5-4h9V16"/><path d="M14 10h3.5l3.5 3.5V16"/>'
    '<circle cx="7" cy="17.5" r="2"/><circle cx="17.5" cy="17.5" r="2"/><path d="M8 5.5h2.5M9.25 4.25v2.5"/>',
  );

  static final String flask = _icon(
    '<path d="M9.5 3v6L5 18a2 2 0 001.8 3h10.4A2 2 0 0019 18l-4.5-9V3"/><path d="M8 3h8M7.5 14h9"/>',
  );

  static final String xray = _icon(
    '<rect x="3" y="3" width="18" height="18" rx="2.5"/>'
    '<path d="M12 7c-2 2.5-2 4-2 5s.5 2.5 2 5c1.5-2.5 2-4 2-5s0-2.5-2-5z"/><path d="M8 12h-.01M16 12h-.01"/>',
  );

  static final String pill = _icon(
    '<rect x="2.5" y="8" width="19" height="8" rx="4" transform="rotate(-40 12 12)"/><path d="M12 8l4 4"/>',
  );

  static final String stethoscope = _icon(
    '<path d="M6 3v5.5a6 6 0 0012 0V3"/><path d="M12 14.5v2a4 4 0 008 0v-1"/><circle cx="20" cy="11" r="2"/>',
  );

  static final String document = _icon(
    '<path d="M13.5 3H6.5A1.5 1.5 0 005 4.5v15A1.5 1.5 0 006.5 21h11a1.5 1.5 0 001.5-1.5V8.5z"/>'
    '<path d="M13.5 3v5.5H19M8.5 13h7M8.5 16.5h4"/>',
  );

  static final String vaccine = _icon(
    '<path d="M17 3l4 4M19 5l-9 9-4 1 1-4 9-9z"/><path d="M13.5 8.5l2 2M11 11l2 2M4 20l3-3"/>',
  );

  static final String heartbeat = _icon(
    '<path d="M3 12h4l2.5-6 4 12L16 12h5"/>',
  );

  static final String chatBubble = _icon(
    '<path d="M20.5 12a8.5 8.5 0 01-11.9 7.8L3.5 21l1.2-5.1A8.5 8.5 0 1120.5 12z"/>',
  );

  static final String wallet = _icon(
    '<path d="M3 7.5A2.5 2.5 0 015.5 5H19a2 2 0 012 2v10a2 2 0 01-2 2H5.5A2.5 2.5 0 013 16.5z"/>'
    '<path d="M3 7.5h16M17 12.5h.01"/>',
  );

  static final String mapPin = _icon(
    '<path d="M12 21s7-5.5 7-11a7 7 0 10-14 0c0 5.5 7 11 7 11z"/><circle cx="12" cy="10" r="2.5"/>',
  );

  static final String settingsGear = _icon(
    '<circle cx="12" cy="12" r="3"/><path d="M12 2.5v2.2M12 19.3v2.2M21.5 12h-2.2M4.7 12H2.5'
    'M18.7 5.3l-1.6 1.6M6.9 17.1l-1.6 1.6M18.7 18.7l-1.6-1.6M6.9 6.9L5.3 5.3"/>',
  );

  static final String shieldLock = _icon(
    '<rect x="4.5" y="10" width="15" height="10.5" rx="2.5"/><path d="M8 10V7a4 4 0 018 0v3"/>',
  );

  static final String logout = _icon(
    '<path d="M15 4.5h3.5A1.5 1.5 0 0120 6v12a1.5 1.5 0 01-1.5 1.5H15"/><path d="M10 16l-4-4 4-4M6 12h9"/>',
  );

  static final String phoneCall = _icon(
    '<path d="M6.5 3.5h3l1.5 4-2 1.5a12 12 0 006 6l1.5-2 4 1.5v3a2 2 0 01-2.2 2A17 17 0 014.5 5.7 2 2 0 016.5 3.5z"/>',
  );

  static final String ambulanceAlt = _icon(
    '<path d="M2.5 16v-4.5l2.5-4h9V16"/><path d="M14 10h3.5l3.5 3.5V16"/>'
    '<circle cx="7" cy="17.5" r="2"/><circle cx="17.5" cy="17.5" r="2"/>',
  );

  static final String clock = _icon(
    '<circle cx="12" cy="12" r="9"/><path d="M12 7v5.5l3.5 2"/>',
  );

  static final String info = _icon(
    '<circle cx="12" cy="12" r="9"/><path d="M12 16v-4M12 8.5h.01"/>',
  );

  static final String checkCircle = _icon(
    '<path d="M5 12.5l4.5 4.5L19 7"/>',
  );

  static final String search = _icon(
    '<circle cx="11" cy="11" r="7"/><path d="M16.2 16.2L21 21"/>',
  );

  static final String globe = _icon(
    '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.5 2.5 3.5 5.5 3.5 9s-1 6.5-3.5 9'
    'c-2.5-2.5-3.5-5.5-3.5-9s1-6.5 3.5-9z"/>',
  );

  static final String home2 = _icon(
    '<path d="M3 10.5L12 3l9 7.5"/><path d="M5 9.5V20h14V9.5"/><path d="M12 11v5M9.5 13.5h5"/>',
  );
}
