
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

/// Network helper for Telr API communication
class NetworkHelper {
  static const String _baseUrl = 'https://secure.telr.com/gateway';
  static const String _paymentEndpoint = '/mobile.xml';
  static const String _completeEndpoint = '/mobile_complete.xml';

  /// Sends payment request to Telr gateway
  static Future<String?> sendPaymentRequest(XmlDocument xml) async {
    try {
      final url = Uri.parse('$_baseUrl$_paymentEndpoint');
      final response = await http.post(
        url,
        body: xml.toString(),
        headers: {
          'Content-Type': 'application/xml',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response.body;
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to process payment request');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Sends completion request to Telr gateway
  static Future<String?> sendCompletionRequest(XmlDocument xml) async {
    try {
      final url = Uri.parse('$_baseUrl$_completeEndpoint');
      final response = await http.post(
        url,
        body: xml.toString(),
        headers: {
          'Content-Type': 'application/xml',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response.body;
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to process completion request');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Validates XML response from Telr
  static bool isValidXmlResponse(String? response) {
    if (response == null || response.isEmpty) return false;
    
    try {
      XmlDocument.parse(response);
      return true;
    } catch (e) {
      return false;
    }
  }
}