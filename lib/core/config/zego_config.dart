class ZegoConfig {
  ZegoConfig._();

  static const int appID = 44672588;

  static const String appSign =
      'd46841713df665320c2bb9abbb9a30c725c4e505e6dec5dcece54be6530319fb';

  static bool get isConfigured => appID != 0 && appSign.isNotEmpty;
}
