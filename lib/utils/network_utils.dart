import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:turbo_network_tools/module/ping_result.dart';

class NetworkUtils {
  static Future<List<PingResult>> ping(String host, int port, int count) async {
    List<PingResult> pingResults = [];
    for (var i = 0; i < count; i++) {
      final delay = await tcpPing(host, port);
      print("第$i次延迟：${delay}ms");
      int lastDelay = 0;
      if (pingResults.isNotEmpty) {
        lastDelay = pingResults.last.delay;
      }
      final jitter = delay - lastDelay;
      final isLoss = delay == 999;
      PingResult pingResult = PingResult(
          delay: delay, jitter: jitter, isLoss: isLoss);
      pingResults.add(pingResult);
    }
    return pingResults;
  }

  static Future<int> tcpPing(String host, int port) async {
    try {
      final socket = await Socket.connect(host, port).timeout(Duration(seconds: 5));

      final start = DateTime.now();
      final data = List.filled(56, 1);
      socket.add(data);
      final response = await socket.first.timeout(Duration(seconds: 5));

      final elapsed = DateTime.now().difference(start);
      await socket.close();
      return elapsed.inMilliseconds;
    } catch (_) {}
    return 999;
  }
}
