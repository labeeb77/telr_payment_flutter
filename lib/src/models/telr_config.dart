/// Configuration class for Telr payment gateway
class TelrConfig {
  /// Store ID provided by Telr
  final String storeId;
  
  /// Authentication key provided by Telr
  final String authKey;
  
  /// Whether to use test mode (default: true)
  final bool isTestMode;
  
  /// Test card type to use when in test mode (optional)
  /// If null, a random successful test card will be used
  final String? testCardType;
  
  /// App name for identification
  final String appName;
  
  /// App version
  final String appVersion;
  
  /// User ID (optional)
  final String? userId;
  
  /// App ID (optional)
  final String? appId;
  
  /// Language code (default: 'en')
  final String language;

  const TelrConfig({
    required this.storeId,
    required this.authKey,
    this.isTestMode = false,
    this.testCardType,
    this.appName = 'Telr Flutter App',
    this.appVersion = '1.1.6',
    this.userId,
    this.appId,
    this.language = 'en',
  });

  /// Creates a copy of this TelrConfig with the given fields replaced
  TelrConfig copyWith({
    String? storeId,
    String? authKey,
    bool? isTestMode,
    String? testCardType,
    String? appName,
    String? appVersion,
    String? userId,
    String? appId,
    String? language,
  }) {
    return TelrConfig(
      storeId: storeId ?? this.storeId,
      authKey: authKey ?? this.authKey,
      isTestMode: isTestMode ?? this.isTestMode,
      testCardType: testCardType ?? this.testCardType,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      userId: userId ?? this.userId,
      appId: appId ?? this.appId,
      language: language ?? this.language,
    );
  }

  @override
  String toString() {
    return 'TelrConfig(storeId: $storeId, isTestMode: $isTestMode, testCardType: $testCardType, appName: $appName)';
  }
}