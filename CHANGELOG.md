## 1.2.0

* ✨ **NEW**: Enhanced save card functionality with proper Telr API integration
* ✨ **NEW**: Helper methods for save card operations (`processInitialPaymentWithSaveCard`, `processPaymentWithSavedCard`)
* ✨ **NEW**: Validation method for saved card references (`isValidSavedCardReference`)
* ✨ **NEW**: Complete save card example demonstrating the full workflow
* 📚 **NEW**: Comprehensive documentation for save card implementation
* 📚 **NEW**: Step-by-step guide for implementing save card functionality
* 🔧 **IMPROVED**: Updated XML builder to properly handle `firstref` parameter
* 🔧 **IMPROVED**: Better API documentation with save card parameters
* 🔧 **IMPROVED**: Enhanced TelrPaymentRequest model with proper save card support

### Save Card Features:
- Proper integration with Telr's stored cards API
- Initial payment with save card option enabled
- Subsequent payments using saved card references
- Transaction reference validation
- Helper methods for easier implementation
- Complete example demonstrating the save card workflow

### Save Card Implementation:
- `processInitialPaymentWithSaveCard()` - Process initial payment with save card
- `processPaymentWithSavedCard()` - Process payment using saved card
- `isValidSavedCardReference()` - Validate saved card references
- Proper handling of `firstref` parameter in XML requests
- Comprehensive documentation and examples

## 1.0.0

* Initial release of Telr Payment Flutter package
* Complete Telr payment gateway integration
* XML-based payment requests
* WebView-based payment flow
* Comprehensive error handling
* Device information collection
* Billing information support
* Card saving functionality
* Response parsing and validation

## 1.1.0

* ✨ **NEW**: Test mode with automatic test card filling
* ✨ **NEW**: Multiple test card scenarios (success, decline, errors)
* ✨ **NEW**: TestCardHelper class with comprehensive test card details
* ✨ **NEW**: Support for specifying test card types in configuration
* ✨ **NEW**: JavaScript injection for auto-filling payment forms
* ✨ **NEW**: Utility methods for working with test cards
* 📚 **NEW**: Comprehensive documentation and examples
* 📚 **NEW**: Test card example demonstrating the feature
* 🔧 **IMPROVED**: Enhanced TelrConfig with testCardType parameter
* 🔧 **IMPROVED**: Better error handling and validation
* 🔧 **IMPROVED**: Updated README with detailed usage instructions

### Test Card Features:
- Automatic test card filling when `isTestMode` is true
- Support for Visa, Mastercard, and American Express test cards
- Multiple scenarios: successful transactions, declined cards, expired cards, etc.
- JavaScript-based form auto-filling for seamless testing
- Utility methods to get test card details and validate card types
- Random test card selection for variety in testing

### Available Test Cards:
- **Successful**: `visa_success`, `mastercard_success`, `amex_success`
- **Declined**: `visa_declined`, `mastercard_declined`, `insufficient_funds`
- **Special**: `expired_card`, `incorrect_cvv`, `processing_error`
