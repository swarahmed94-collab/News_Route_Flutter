import 'package:flutter/services.dart';

class ExternalArticleOpener {
  const ExternalArticleOpener._();

  static const MethodChannel _channel = MethodChannel('news_route/article');

  static Future<void> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      return;
    }
    await _channel.invokeMethod<void>('openUrl', <String, String>{'url': url});
  }

  static Future<void> share(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) return;
    await _channel.invokeMethod<void>('shareUrl', <String, String>{'url': url});
  }
}
