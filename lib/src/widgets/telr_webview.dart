import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml/xml.dart';
import '../models/telr_config.dart';
import '../models/telr_response.dart';
import '../services/network_helper.dart';
import '../utils/xml_builder_helper.dart';

/// WebView widget for handling Telr payment flow
class TelrWebView extends StatefulWidget {
  final String paymentUrl;
  final String paymentCode;
  final TelrConfig config;
  final Function(TelrPaymentResponse) onPaymentComplete;

  const TelrWebView({
    super.key,
    required this.paymentUrl,
    required this.paymentCode,
    required this.config,
    required this.onPaymentComplete,
  });

  @override
  State<TelrWebView> createState() => _TelrWebViewState();
}

class _TelrWebViewState extends State<TelrWebView> {
  late final WebViewController controller;
  bool _isProcessing = false;
  bool _hasProcessed = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            _hasProcessed = false;
          },
          onPageFinished: (String url) {
            _handlePageFinished(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePageFinished(String url) {
    if (url.contains('close') && !_hasProcessed) {
      _hasProcessed = true;
      _processPaymentCompletion();
    } else if (url.contains('abort') && !_hasProcessed) {
      _hasProcessed = true;
      _handlePaymentAbort();
    }
  }

  Future<void> _processPaymentCompletion() async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      final completionXml = XmlBuilderHelper.buildCompletionXml(
        config: widget.config,
        code: widget.paymentCode,
      );

      final response = await NetworkHelper.sendCompletionRequest(completionXml);
      
      if (response == null) {
        widget.onPaymentComplete(
          TelrPaymentResponse.failure(errorMessage: 'Failed to get completion response'),
        );
        return;
      }

      final paymentResponse = _parseCompletionResponse(response);
      widget.onPaymentComplete(paymentResponse);

    } catch (e) {
      widget.onPaymentComplete(
        TelrPaymentResponse.failure(errorMessage: 'Error processing payment: $e'),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _handlePaymentAbort() {
    widget.onPaymentComplete(
      TelrPaymentResponse.failure(errorMessage: 'Payment was cancelled by user'),
    );
  }

  TelrPaymentResponse _parseCompletionResponse(String response) {
    try {
      final doc = XmlDocument.parse(response);
      
      // Parse auth section
      final auth = doc.findAllElements('auth').firstOrNull;
      if (auth == null) {
        return TelrPaymentResponse.failure(
          errorMessage: 'Invalid response format: missing auth section',
        );
      }

      final status = auth.findAllElements('status').map((node) => node.text).firstOrNull;
      final message = auth.findAllElements('message').map((node) => node.text).firstOrNull;
      final code = auth.findAllElements('code').map((node) => node.text).firstOrNull;
      final ref = auth.findAllElements('ref').map((node) => node.text).firstOrNull;
      
      // Parse card details if available
      final card = auth.findAllElements('card').firstOrNull;
      CardInfo? cardInfo;
      
      if (card != null) {
        final cardNumber = card.findAllElements('number').map((node) => node.text).firstOrNull;
        final expiry = card.findAllElements('expiry').firstOrNull;
        String? expiryMonth;
        String? expiryYear;
        
        if (expiry != null) {
          expiryMonth = expiry.findAllElements('month').map((node) => node.text).firstOrNull;
          expiryYear = expiry.findAllElements('year').map((node) => node.text).firstOrNull;
        }
        
        cardInfo = CardInfo(
          number: cardNumber,
          expiryMonth: expiryMonth,
          expiryYear: expiryYear,
        );
      }
      
      // Parse trace information
      final trace = doc.findAllElements('trace').map((node) => node.text).firstOrNull;
      
      // Create raw response map
      final rawResponse = <String, dynamic>{
        'status': status,
        'message': message,
        'code': code,
        'ref': ref,
        'trace': trace,
      };

      if (status == 'A' && ref != null && ref.isNotEmpty) {
        // Transaction successful
        return TelrPaymentResponse.success(
          transactionRef: ref,
          message: message ?? 'Transaction successful',
          authCode: code,
          cardInfo: cardInfo,
          trace: trace,
          rawResponse: rawResponse,
        );
      } else {
        // Transaction failed or pending
        String errorMessage = message ?? 'Transaction failed';
        if (code != null) {
          errorMessage += ' (Code: $code)';
        }
        
        return TelrPaymentResponse.failure(
          errorMessage: errorMessage,
          statusCode: status,
          authCode: code,
          trace: trace,
          rawResponse: rawResponse,
        );
      }
    } catch (e) {
      return TelrPaymentResponse.failure(
        errorMessage: 'Error parsing response: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black87),
        ),
        leading: TextButton(
          onPressed: () {
            widget.onPaymentComplete(
              TelrPaymentResponse.failure(errorMessage: 'Payment cancelled by user'),
            );
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        leadingWidth: 80,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing payment...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}