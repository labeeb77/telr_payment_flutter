import 'dart:math';
import 'package:xml/xml.dart';
import '../models/telr_config.dart';
import '../models/telr_request.dart';

/// Helper class for building XML requests for Telr API
import 'dart:math';
import 'package:xml/xml.dart';
import '../models/telr_config.dart';
import '../models/telr_request.dart';

/// Helper class for building XML requests for Telr API
class XmlBuilderHelper {
  /// Builds payment XML request
  static XmlDocument buildPaymentXml({
    required TelrConfig config,
    required TelrPaymentRequest request,
    required Map<String, String> deviceInfo,
  }) {
    // Validate required fields
    _validatePaymentRequest(config, request);
    
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    
    builder.element('mobile', nest: () {
      // Store configuration
      builder.element('store', nest: () {
        builder.text(config.storeId);
      });
      
      builder.element('key', nest: () {
        builder.text(config.authKey);
      });

      // Device information
      builder.element('device', nest: () {
        builder.element('type', nest: () {
          builder.text(deviceInfo['type'] ?? 'Android');
        });
        builder.element('id', nest: () {
          builder.text(deviceInfo['id'] ?? 'unknown');
        });
        builder.element('agent', nest: () {
          builder.text(deviceInfo['agent'] ?? 'Mozilla/5.0 (Mobile)');
        });
        builder.element('accept', nest: () {
          builder.text(deviceInfo['accept'] ?? 'text/html,application/xhtml+xml');
        });
      });

      // App information
      builder.element('app', nest: () {
        builder.element('name', nest: () {
          builder.text(config.appName);
        });
        builder.element('version', nest: () {
          builder.text(config.appVersion);
        });
        if (config.userId != null && config.userId!.isNotEmpty) {
          builder.element('user', nest: () {
            builder.text(config.userId!);
          });
        }
        if (config.appId != null && config.appId!.isNotEmpty) {
          builder.element('id', nest: () {
            builder.text(config.appId!);
          });
        }
      });

      // Transaction details
      builder.element('tran', nest: () {
        builder.element('test', nest: () {
          builder.text(config.isTestMode ? '1' : '0');
        });
        builder.element('type', nest: () {
          builder.text(request.transactionType);
        });
        builder.element('class', nest: () {
          builder.text(request.transactionClass);
        });
        builder.element('cartid', nest: () {
          builder.text(request.cartId ?? _generateCartId());
        });
        builder.element('description', nest: () {
          builder.text(request.description);
        });
        builder.element('currency', nest: () {
          builder.text(request.currency.toUpperCase());
        });
        builder.element('amount', nest: () {
          // Ensure proper formatting - this is critical!
          builder.text(_formatAmount(request.amount));
        });
        
        // Add firstref if save card is enabled and firstRef is provided
        if (request.saveCard && request.firstRef != null && request.firstRef!.isNotEmpty) {
          builder.element('firstref', nest: () {
            builder.text(request.firstRef!);
          });
        }
        
        builder.element('language', nest: () {
          builder.text(config.language);
        });
      });

      // Billing information
      builder.element('billing', nest: () {
        builder.element('name', nest: () {
          builder.element('title', nest: () {
            builder.text(request.billingInfo.title);
          });
          builder.element('first', nest: () {
            builder.text(request.billingInfo.firstName);
          });
          builder.element('last', nest: () {
            builder.text(request.billingInfo.lastName);
          });
        });
        
        builder.element('address', nest: () {
          builder.element('line1', nest: () {
            builder.text(request.billingInfo.addressLine1);
          });
          builder.element('city', nest: () {
            builder.text(request.billingInfo.city);
          });
          builder.element('region', nest: () {
            builder.text(request.billingInfo.region);
          });
          builder.element('country', nest: () {
            builder.text(request.billingInfo.country);
          });
          builder.element('zip', nest: () {
            builder.text(request.billingInfo.zipCode);
          });
        });
        
        builder.element('phone', nest: () {
          builder.text(request.billingInfo.phone);
        });
        builder.element('email', nest: () {
          builder.text(request.billingInfo.email);
        });
      });

      // Customer reference
      builder.element('custref', nest: () {
        builder.text(request.customerRef ?? 'CUSTOMER_REF_${DateTime.now().millisecondsSinceEpoch}');
      });
    });

    return builder.buildDocument();
  }

  /// Builds completion XML request
  static XmlDocument buildCompletionXml({
    required TelrConfig config,
    required String code,
  }) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    
    builder.element('mobile', nest: () {
      builder.element('store', nest: () {
        builder.text(config.storeId);
      });
      builder.element('key', nest: () {
        builder.text(config.authKey);
      });
      builder.element('complete', nest: () {
        builder.text(code);
      });
    });

    return builder.buildDocument();
  }

  /// Validates payment request data
  static void _validatePaymentRequest(TelrConfig config, TelrPaymentRequest request) {
    if (config.storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }
    if (config.authKey.isEmpty) {
      throw ArgumentError('Auth key cannot be empty');
    }
    if (request.amount <= 0) {
      throw ArgumentError('Amount must be greater than 0');
    }
    if (request.currency.isEmpty) {
      throw ArgumentError('Currency cannot be empty');
    }
    if (request.description.isEmpty) {
      throw ArgumentError('Description cannot be empty');
    }
  }

  /// Formats amount to ensure proper decimal places
  static String _formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }

  /// Generates a random cart ID
  static String _generateCartId() {
    return (100000000 + Random().nextInt(899999999)).toString();
  }
}