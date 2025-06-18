/// Helper class for Telr test card details
/// Based on: https://docs.telr.com/reference/test-cards
class TestCardHelper {
  /// Test card details for successful transactions
  static const Map<String, Map<String, String>> successfulCards = {
    'visa_success': {
      'number': '4111111111111111',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '123',
      'description': 'Visa - Successful Transaction',
    },
    'mastercard_success': {
      'number': '5555555555554444',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '123',
      'description': 'Mastercard - Successful Transaction',
    },
    'amex_success': {
      'number': '378282246310005',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '1234',
      'description': 'American Express - Successful Transaction',
    },
  };

  /// Test card details for failed transactions
  static const Map<String, Map<String, String>> failedCards = {
    'visa_declined': {
      'number': '4000000000000002',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '123',
      'description': 'Visa - Declined Transaction',
    },
    'mastercard_declined': {
      'number': '5105105105105100',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '123',
      'description': 'Mastercard - Declined Transaction',
    },
    'insufficient_funds': {
      'number': '4000000000009995',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '123',
      'description': 'Insufficient Funds',
    },
  };

  /// Test card details for specific scenarios
  static const Map<String, Map<String, String>> scenarioCards = {
    'expired_card': {
      'number': '4000000000000069',
      'expiry_month': '12',
      'expiry_year': '20',
      'cvv': '123',
      'description': 'Expired Card',
    },
    'incorrect_cvv': {
      'number': '4000000000000127',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '999',
      'description': 'Incorrect CVV',
    },
    'processing_error': {
      'number': '4000000000000119',
      'expiry_month': '12',
      'expiry_year': '25',
      'cvv': '123',
      'description': 'Processing Error',
    },
  };

  /// Get a random successful test card
  static Map<String, String> getRandomSuccessfulCard() {
    final cards = successfulCards.values.toList();
    final random = DateTime.now().millisecondsSinceEpoch % cards.length;
    return cards[random];
  }

  /// Get a specific test card by type
  static Map<String, String>? getTestCard(String cardType) {
    return successfulCards[cardType] ?? 
           failedCards[cardType] ?? 
           scenarioCards[cardType];
  }

  /// Get all available test card types
  static List<String> getAllTestCardTypes() {
    return [
      ...successfulCards.keys,
      ...failedCards.keys,
      ...scenarioCards.keys,
    ];
  }

  /// Get test card details for JavaScript injection
  static String getTestCardJavaScript(Map<String, String> cardDetails) {
    return '''
      // Auto-fill test card details
      setTimeout(function() {
        // Fill card number
        var cardNumberField = document.querySelector('input[name*="card"], input[name*="number"], input[placeholder*="card"], input[placeholder*="number"]');
        if (cardNumberField) {
          cardNumberField.value = '${cardDetails['number']}';
          cardNumberField.dispatchEvent(new Event('input', { bubbles: true }));
          cardNumberField.dispatchEvent(new Event('change', { bubbles: true }));
        }
        
        // Fill expiry month
        var expiryMonthField = document.querySelector('select[name*="month"], input[name*="month"], select[placeholder*="month"]');
        if (expiryMonthField) {
          if (expiryMonthField.tagName === 'SELECT') {
            expiryMonthField.value = '${cardDetails['expiry_month']}';
          } else {
            expiryMonthField.value = '${cardDetails['expiry_month']}';
          }
          expiryMonthField.dispatchEvent(new Event('change', { bubbles: true }));
        }
        
        // Fill expiry year
        var expiryYearField = document.querySelector('select[name*="year"], input[name*="year"], select[placeholder*="year"]');
        if (expiryYearField) {
          if (expiryYearField.tagName === 'SELECT') {
            expiryYearField.value = '${cardDetails['expiry_year']}';
          } else {
            expiryYearField.value = '${cardDetails['expiry_year']}';
          }
          expiryYearField.dispatchEvent(new Event('change', { bubbles: true }));
        }
        
        // Fill CVV
        var cvvField = document.querySelector('input[name*="cvv"], input[name*="cvc"], input[name*="security"], input[placeholder*="cvv"], input[placeholder*="cvc"]');
        if (cvvField) {
          cvvField.value = '${cardDetails['cvv']}';
          cvvField.dispatchEvent(new Event('input', { bubbles: true }));
          cvvField.dispatchEvent(new Event('change', { bubbles: true }));
        }
        
        console.log('Test card details auto-filled: ${cardDetails['description']}');
      }, 1000);
    ''';
  }
} 