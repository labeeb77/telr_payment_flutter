/// Response model for Telr payment transactions
class TelrPaymentResponse {
  /// Whether the payment was successful
  final bool isSuccess;
  
  /// Transaction reference number
  final String? transactionRef;
  
  /// Payment status code
  final String? statusCode;
  
  /// Response message
  final String? message;
  
  /// Error message (if any)
  final String? errorMessage;
  
  /// Authorization code
  final String? authCode;
  
  /// Card information (if available)
  final CardInfo? cardInfo;
  
  /// Trace information
  final String? trace;
  
  /// Raw response data
  final Map<String, dynamic>? rawResponse;

  const TelrPaymentResponse({
    required this.isSuccess,
    this.transactionRef,
    this.statusCode,
    this.message,
    this.errorMessage,
    this.authCode,
    this.cardInfo,
    this.trace,
    this.rawResponse,
  });

  /// Creates a successful response
  factory TelrPaymentResponse.success({
    required String transactionRef,
    String? message,
    String? authCode,
    CardInfo? cardInfo,
    String? trace,
    Map<String, dynamic>? rawResponse,
  }) {
    return TelrPaymentResponse(
      isSuccess: true,
      transactionRef: transactionRef,
      statusCode: 'A',
      message: message ?? 'Transaction successful',
      authCode: authCode,
      cardInfo: cardInfo,
      trace: trace,
      rawResponse: rawResponse,
    );
  }

  /// Creates a failed response
  factory TelrPaymentResponse.failure({
    required String errorMessage,
    String? statusCode,
    String? authCode,
    String? trace,
    Map<String, dynamic>? rawResponse,
  }) {
    return TelrPaymentResponse(
      isSuccess: false,
      statusCode: statusCode ?? 'E',
      errorMessage: errorMessage,
      authCode: authCode,
      trace: trace,
      rawResponse: rawResponse,
    );
  }

  @override
  String toString() {
    return 'TelrPaymentResponse(isSuccess: $isSuccess, transactionRef: $transactionRef, message: ${message ?? errorMessage})';
  }
}

/// Card information from the payment response
class CardInfo {
  /// Masked card number
  final String? number;
  
  /// Expiry month
  final String? expiryMonth;
  
  /// Expiry year
  final String? expiryYear;
  
  /// Card type (Visa, MasterCard, etc.)
  final String? type;

  const CardInfo({
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.type,
  });

  /// Gets formatted expiry date
  String? get formattedExpiry {
    if (expiryMonth != null && expiryYear != null) {
      return '$expiryMonth/$expiryYear';
    }
    return null;
  }

  @override
  String toString() {
    return 'CardInfo(number: $number, expiry: $formattedExpiry, type: $type)';
  }
}