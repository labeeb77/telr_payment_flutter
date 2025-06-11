import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// Service for getting device information
class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Gets device information as a map
  static Future<Map<String, String>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return {
          'type': 'Android',
          'id': androidInfo.id,
          'agent': 'Mozilla/5.0 (Linux; Android ${androidInfo.version.release}; ${androidInfo.model}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8'
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return {
          'type': 'iPhone',
          'id': iosInfo.identifierForVendor ?? 'unknown',
          'agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS ${iosInfo.systemVersion.replaceAll('.', '_')} like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
          'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        };
      } else {
        // Fallback for other platforms
        return {
          'type': 'Unknown',
          'id': 'fallback_device_id_${DateTime.now().millisecondsSinceEpoch}',
          'agent': 'Mozilla/5.0 (Mobile; rv:40.0) Gecko/40.0 Firefox/40.0',
          'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        };
      }
    } catch (e) {
      // Return fallback device info if there's an error
      return {
        'type': Platform.isAndroid ? 'Android' : 'iPhone',
        'id': 'fallback_device_id_${DateTime.now().millisecondsSinceEpoch}',
        'agent': 'Mozilla/5.0 (Mobile; rv:40.0) Gecko/40.0 Firefox/40.0',
        'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
      };
    }
  }
}