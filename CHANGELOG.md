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
