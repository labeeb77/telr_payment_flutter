import 'billing_info.dart';

/// Payment request model for Telr gateway
class TelrPaymentRequest {
  /// Payment amount
  final double amount;
  
  /// Currency code (3-letter ISO code)
  final String currency;
  
  /// Payment description
  final String description;
  
  /// Billing information
  final BillingInfo billingInfo;
  
  /// Customer reference (optional)
  final String? customerRef;
  
  /// Cart ID (optional, will be auto-generated if not provided)
  final String? cartId;
  
  /// Transaction type (default: 'paypage')
  final String transactionType;
  
  /// Transaction class (default: 'ecom')
  final String transactionClass;
  
  /// Whether to save card for future payments
  final bool saveCard;
  
  /// First reference for saved card payments (optional)
  final String? firstRef;

  const TelrPaymentRequest({
    required this.amount,
    required this.currency,
    required this.description,
    required this.billingInfo,
    this.customerRef,
    this.cartId,
    this.transactionType = 'paypage',
    this.transactionClass = 'ecom',
    this.saveCard = false,
    this.firstRef,
  });

  /// Creates a copy of this TelrPaymentRequest with the given fields replaced
  TelrPaymentRequest copyWith({
    double? amount,
    String? currency,
    String? description,
    BillingInfo? billingInfo,
    String? customerRef,
    String? cartId,
    String? transactionType,
    String? transactionClass,
    bool? saveCard,
    String? firstRef,
  }) {
    return TelrPaymentRequest(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      billingInfo: billingInfo ?? this.billingInfo,
      customerRef: customerRef ?? this.customerRef,
      cartId: cartId ?? this.cartId,
      transactionType: transactionType ?? this.transactionType,
      transactionClass: transactionClass ?? this.transactionClass,
      saveCard: saveCard ?? this.saveCard,
      firstRef: firstRef ?? this.firstRef,
    );
  }

  /// Validates the request data
  bool isValid() {
    if (amount <= 0) return false;
    if (currency.length != 3) return false;
    if (description.isEmpty) return false;
    return true;
  }

  /// Gets formatted amount string
  String get formattedAmount => amount.toStringAsFixed(2);

  @override
  String toString() {
    return 'TelrPaymentRequest(amount: $amount, currency: $currency, description: $description)';
  }
}


