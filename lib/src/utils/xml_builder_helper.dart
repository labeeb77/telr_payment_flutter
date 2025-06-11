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
        if (config.userId != null) {
          builder.element('user', nest: () {
            builder.text(config.userId!);
          });
        }
        if (config.appId != null) {
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
          builder.text(request.formattedAmount);
        });
        
        // Add firstref if save card is enabled and firstRef is provided
        if (request.saveCard && request.firstRef != null) {
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

  /// Generates a random cart ID
  static String _generateCartId() {
    return (100000000 + Random().nextInt(999999999)).toString();
  }
}