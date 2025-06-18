import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import '../models/telr_config.dart';
import '../models/telr_request.dart';
import '../models/telr_response.dart';
import '../services/device_info_service.dart';
import '../services/network_helper.dart';
import '../widgets/telr_webview.dart';
import '../utils/xml_builder_helper.dart';
import '../utils/test_card_helper.dart';

/// Main service class for Telr payment processing
class TelrPayment {
  /// Process a payment request
  static Future<TelrPaymentResponse> processPayment({
    required BuildContext context,
    required TelrConfig config,
    required TelrPaymentRequest request,
  }) async {
    try {
      // Validate request
      if (!request.isValid()) {
        return TelrPaymentResponse.failure(
          errorMessage: 'Invalid payment request data',
        );
      }

      // Get device information
      final deviceInfo = await DeviceInfoService.getDeviceInfo();

      // Build payment XML
      final paymentXml = XmlBuilderHelper.buildPaymentXml(
        config: config,
        request: request,
        deviceInfo: deviceInfo,
      );

      // Send payment request
      final response = await NetworkHelper.sendPaymentRequest(paymentXml);
      
      if (response == null) {
        return TelrPaymentResponse.failure(
          errorMessage: 'Failed to connect to payment gateway',
        );
      }

      // Parse initial response
      final paymentInitResponse = _parseInitialResponse(response);
      
      if (!paymentInitResponse.isSuccess) {
        return paymentInitResponse;
      }

      // Get payment URL and code from response
      final paymentUrl = paymentInitResponse.rawResponse?['payment_url'] as String?;
      final paymentCode = paymentInitResponse.rawResponse?['payment_code'] as String?;

      if (paymentUrl == null || paymentCode == null) {
        return TelrPaymentResponse.failure(
          errorMessage: 'Invalid payment URL received from gateway',
        );
      }

      // Launch WebView for payment
      final webViewResponse = await Navigator.push<TelrPaymentResponse>(
        context,
        MaterialPageRoute(
          builder: (context) => TelrWebView(
            paymentUrl: paymentUrl,
            paymentCode: paymentCode,
            config: config,
            onPaymentComplete: (response) {
              Navigator.of(context).pop(response);
            },
          ),
        ),
      );

      return webViewResponse ?? TelrPaymentResponse.failure(
        errorMessage: 'Payment was cancelled',
      );

    } catch (e) {
      return TelrPaymentResponse.failure(
        errorMessage: 'Error processing payment: $e',
      );
    }
  }

  /// Parse the initial payment response
  static TelrPaymentResponse _parseInitialResponse(String response) {
    try {
      final doc = XmlDocument.parse(response);
      
      // Check for auth status
      final auth = doc.findAllElements('auth').firstOrNull;
      if (auth != null) {
        final status = auth.findAllElements('status').map((node) => node.text).firstOrNull;
        final message = auth.findAllElements('message').map((node) => node.text).firstOrNull;
        final code = auth.findAllElements('code').map((node) => node.text).firstOrNull;
        
        if (status == 'E') {
          String errorMessage = message ?? 'Payment initialization failed';
          if (code != null) {
            errorMessage += ' (Code: $code)';
          }
          return TelrPaymentResponse.failure(
            errorMessage: errorMessage,
            statusCode: status,
            authCode: code,
          );
        }
      }

      // Check for start URL and code
      final start = doc.findAllElements('start').map((node) => node.text).firstOrNull;
      final code = doc.findAllElements('code').map((node) => node.text).firstOrNull;

      if (start != null && code != null) {
        return TelrPaymentResponse.success(
          transactionRef: code,
          message: 'Payment initialized successfully',
          rawResponse: {
            'payment_url': start,
            'payment_code': code,
          },
        );
      } else {
        return TelrPaymentResponse.failure(
          errorMessage: 'Invalid response from payment gateway',
        );
      }
    } catch (e) {
      return TelrPaymentResponse.failure(
        errorMessage: 'Error parsing payment response: $e',
      );
    }
  }

  /// Validate payment configuration
  static bool validateConfig(TelrConfig config) {
    if (config.storeId.isEmpty) return false;
    if (config.authKey.isEmpty) return false;
    return true;
  }

  /// Get formatted amount for display
  static String formatAmount(double amount, String currency) {
    return '${amount.toStringAsFixed(2)} $currency';
  }

  /// Validate currency code
  static bool isValidCurrency(String currency) {
    return currency.length == 3 && currency.toUpperCase() == currency;
  }

  /// Validate amount
  static bool isValidAmount(double amount) {
    return amount > 0;
  }

  /// Get all available test card types
  static List<String> getAvailableTestCardTypes() {
    return TestCardHelper.getAllTestCardTypes();
  }

  /// Get test card details for a specific type
  static Map<String, String>? getTestCardDetails(String cardType) {
    return TestCardHelper.getTestCard(cardType);
  }

  /// Validate if a test card type is valid
  static bool isValidTestCardType(String cardType) {
    return TestCardHelper.getTestCard(cardType) != null;
  }

  /// Get a random successful test card
  static Map<String, String> getRandomSuccessfulTestCard() {
    return TestCardHelper.getRandomSuccessfulCard();
  }

  /// Check if the current configuration is in test mode
  static bool isTestMode(TelrConfig config) {
    return config.isTestMode;
  }

  /// Process initial payment with save card enabled
  /// This should be used for the first payment when you want to save the card
  static Future<TelrPaymentResponse> processInitialPaymentWithSaveCard({
    required BuildContext context,
    required TelrConfig config,
    required TelrPaymentRequest request,
  }) async {
    // Enable save card for initial payment
    final saveCardRequest = request.copyWith(saveCard: true);
    
    return await processPayment(
      context: context,
      config: config,
      request: saveCardRequest,
    );
  }

  /// Process payment using a previously saved card
  /// This should be used for subsequent payments using a saved card
  static Future<TelrPaymentResponse> processPaymentWithSavedCard({
    required BuildContext context,
    required TelrConfig config,
    required TelrPaymentRequest request,
    required String savedTransactionRef,
  }) async {
    // Use the saved transaction reference
    final savedCardRequest = request.copyWith(firstRef: savedTransactionRef);
    
    return await processPayment(
      context: context,
      config: config,
      request: savedCardRequest,
    );
  }

  /// Validate if a transaction reference is valid for saved card payments
  static bool isValidSavedCardReference(String transactionRef) {
    return transactionRef.isNotEmpty && transactionRef.length >= 10;
  }
}