import 'dart:math';
import 'package:xml/xml.dart';
import '../models/telr_config.dart';
import '../models/telr_request.dart';

/// Helper class for building XML requests for Telr API
class XmlBuilderHelper {
  /// Validates payment request data
  static void _validatePaymentRequest(TelrConfig config, TelrPaymentRequest request) {
    if (config.storeId.isEmpty) {
      throw Exception('Store ID is required');
    }
    if (config.authKey.isEmpty) {
      throw Exception('Auth key is required');
    }
    if (request.amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }
    if (request.currency.length != 3) {
      throw Exception('Currency must be a 3-letter code');
    }
    if (request.description.isEmpty) {
      throw Exception('Description is required');
    }
  }

  /// Generates a unique cart ID
  static String _generateCartId() {
    return (100000000 + Random().nextInt(999999999)).toString();
  }

  /// Formats amount to 2 decimal places
  static String _formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }

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
          builder.text('Telr');
        });
        builder.element('version', nest: () {
          builder.text('1.1.6');
        });
        builder.element('user', nest: () {
          builder.text('2');
        });
        builder.element('id', nest: () {
          builder.text('123');
        });
      });

      // Transaction details
      builder.element('tran', nest: () {
        builder.element('test', nest: () {
          builder.text(config.isTestMode ? '1' : '0');
        });
        builder.element('type', nest: () {
          builder.text('paypage');
        });
        builder.element('class', nest: () {
          builder.text('ecom');
        });
        builder.element('cartid', nest: () {
          builder.text(_generateCartId());
        });
        builder.element('description', nest: () {
          builder.text('Test for Mobile API order');
        });
        builder.element('currency', nest: () {
          builder.text(request.currency.toUpperCase());
        });
        builder.element('amount', nest: () {
          builder.text(_formatAmount(request.amount));
        });
        
        if (request.saveCard && request.firstRef != null && request.firstRef!.isNotEmpty) {
          builder.element('firstref', nest: () {
            builder.text(request.firstRef!);
          });
        }
        
        builder.element('language', nest: () {
          builder.text('en');
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
        builder.text('CUSTOMER_REF_${DateTime.now().millisecondsSinceEpoch}');
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
}