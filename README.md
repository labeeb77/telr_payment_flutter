<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Telr Payment Flutter

A Flutter package for integrating Telr payment gateway into your Flutter applications. This package provides a complete solution for processing payments through Telr's payment gateway with support for test mode and automatic test card filling.

## Features

- ✅ Complete Telr payment gateway integration
- ✅ XML-based payment requests
- ✅ WebView-based payment flow
- ✅ Test mode support with automatic test card filling
- ✅ Multiple test card scenarios (success, decline, errors)
- ✅ Comprehensive error handling
- ✅ Device information collection
- ✅ Billing information support
- ✅ Card saving functionality
- ✅ Response parsing and validation

## Getting Started

### Prerequisites

- Flutter SDK (2.0 or higher)
- Telr merchant account with Store ID and Auth Key
- Internet connectivity for payment processing

### Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  telr_payment_flutter: ^1.0.0
```

### Platform Setup

#### Android
Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS
No additional setup required for iOS.

## Usage

### Basic Payment Processing

```dart
import 'package:flutter/material.dart';
import 'package:telr_payment_flutter/telr_payment_flutter.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _processPayment(context),
          child: Text('Pay Now'),
        ),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    // Create Telr configuration
    final config = TelrConfig(
      storeId: 'your_store_id',
      authKey: 'your_auth_key',
      isTestMode: true, // Set to false for production
    );

    // Create billing information
    final billingInfo = BillingInfo(
      title: 'Mr',
      firstName: 'John',
      lastName: 'Doe',
      addressLine1: '123 Main Street',
      city: 'Dubai',
      region: 'Dubai',
      country: 'AE',
      zipCode: '12345',
      phone: '+971501234567',
      email: 'john.doe@example.com',
    );

    // Create payment request
    final request = TelrPaymentRequest(
      amount: 100.0,
      currency: 'AED',
      description: 'Payment for services',
      billingInfo: billingInfo,
      saveCard: false,
    );

    try {
      final response = await TelrPayment.processPayment(
        context: context,
        config: config,
        request: request,
      );

      if (response.isSuccess) {
        print('Payment successful: ${response.transactionRef}');
      } else {
        print('Payment failed: ${response.errorMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
```

### Test Mode with Auto-Filled Test Cards

The package includes a powerful test mode feature that automatically fills test card details when `isTestMode` is enabled:

```dart
// Enable test mode with automatic test card filling
final config = TelrConfig(
  storeId: 'your_store_id',
  authKey: 'your_auth_key',
  isTestMode: true, // This enables automatic test card filling
);

// Optionally specify a particular test card type
final configWithSpecificCard = TelrConfig(
  storeId: 'your_store_id',
  authKey: 'your_auth_key',
  isTestMode: true,
  testCardType: 'visa_success', // Use specific test card
);
```

### Available Test Cards

The package provides various test card scenarios:

#### Successful Transactions
- `visa_success` - Visa card for successful transactions
- `mastercard_success` - Mastercard for successful transactions
- `amex_success` - American Express for successful transactions

#### Failed Transactions
- `visa_declined` - Visa card for declined transactions
- `mastercard_declined` - Mastercard for declined transactions
- `insufficient_funds` - Card with insufficient funds

#### Special Scenarios
- `expired_card` - Expired card
- `incorrect_cvv` - Card with incorrect CVV
- `processing_error` - Card causing processing errors

### Working with Test Cards

```dart
// Get all available test card types
final availableCards = TelrPayment.getAvailableTestCardTypes();

// Get details for a specific test card
final cardDetails = TelrPayment.getTestCardDetails('visa_success');
if (cardDetails != null) {
  print('Card Number: ${cardDetails['number']}');
  print('Expiry: ${cardDetails['expiry_month']}/${cardDetails['expiry_year']}');
  print('CVV: ${cardDetails['cvv']}');
  print('Description: ${cardDetails['description']}');
}

// Get a random successful test card
final randomCard = TelrPayment.getRandomSuccessfulTestCard();

// Validate a test card type
final isValid = TelrPayment.isValidTestCardType('visa_success');
```

### Advanced Configuration

```dart
final config = TelrConfig(
  storeId: 'your_store_id',
  authKey: 'your_auth_key',
  isTestMode: true,
  testCardType: 'visa_success',
  appName: 'My Payment App',
  appVersion: '1.0.0',
  userId: 'user123',
  appId: 'app123',
  language: 'en',
);
```

### Handling Payment Responses

```dart
final response = await TelrPayment.processPayment(
  context: context,
  config: config,
  request: request,
);

if (response.isSuccess) {
  // Payment successful
  print('Transaction Reference: ${response.transactionRef}');
  print('Message: ${response.message}');
  print('Auth Code: ${response.authCode}');
  
  // Access card information if available
  if (response.cardInfo != null) {
    print('Card Number: ${response.cardInfo!.number}');
    print('Expiry: ${response.cardInfo!.expiryMonth}/${response.cardInfo!.expiryYear}');
  }
  
  // Access raw response data
  print('Raw Response: ${response.rawResponse}');
} else {
  // Payment failed
  print('Error: ${response.errorMessage}');
  print('Status Code: ${response.statusCode}');
  print('Auth Code: ${response.authCode}');
  print('Trace: ${response.trace}');
}
```

## API Reference

### TelrConfig

Configuration class for Telr payment gateway.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `storeId` | String | Yes | Your Telr store ID |
| `authKey` | String | Yes | Your Telr authentication key |
| `isTestMode` | bool | No | Enable test mode (default: true) |
| `testCardType` | String? | No | Specific test card type to use |
| `appName` | String | No | Application name (default: 'Telr Flutter App') |
| `appVersion` | String | No | Application version (default: '1.1.6') |
| `userId` | String? | No | User identifier |
| `appId` | String? | No | Application identifier |
| `language` | String | No | Language code (default: 'en') |

### TelrPaymentRequest

Payment request configuration.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `amount` | double | Yes | Payment amount |
| `currency` | String | Yes | Currency code (3 letters) |
| `description` | String | Yes | Payment description |
| `billingInfo` | BillingInfo | Yes | Customer billing information |
| `saveCard` | bool | No | Save card for future use (default: false) |
| `firstRef` | String? | No | Reference for saved card |

### BillingInfo

Customer billing information.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `title` | String | Yes | Customer title (Mr, Mrs, etc.) |
| `firstName` | String | Yes | Customer first name |
| `lastName` | String | Yes | Customer last name |
| `addressLine1` | String | Yes | Address line 1 |
| `city` | String | Yes | City |
| `region` | String | Yes | Region/State |
| `country` | String | Yes | Country code (2 letters) |
| `zipCode` | String | Yes | ZIP/Postal code |
| `phone` | String | Yes | Phone number |
| `email` | String | Yes | Email address |

## Error Handling

The package provides comprehensive error handling:

```dart
try {
  final response = await TelrPayment.processPayment(
    context: context,
    config: config,
    request: request,
  );
  
  // Handle response
} catch (e) {
  // Handle exceptions
  print('Payment error: $e');
}
```

Common error scenarios:
- Network connectivity issues
- Invalid configuration
- Invalid payment request data
- Payment gateway errors
- User cancellation

## Testing

For testing purposes, always use test mode with the provided test cards. Never use real card details in test mode.

### Test Mode Best Practices

1. Always set `isTestMode: true` during development
2. Use the provided test cards for different scenarios
3. Test both successful and failed payment flows
4. Verify error handling with declined cards
5. Test with different currencies and amounts

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please contact:
- Email: support@telr.com
- Documentation: https://docs.telr.com
- Test Cards: https://docs.telr.com/reference/test-cards
