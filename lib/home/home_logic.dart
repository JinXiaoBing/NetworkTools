import 'dart:math';

import 'package:get/get.dart';
import 'package:turbo_network_tools/module/ping_result.dart';
import 'package:turbo_network_tools/utils/network_utils.dart';

import 'home_state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();
  RxList<PingResult> pingResults = RxList();
  RxString statistics = RxString("");

  Future<void> startPing(String ip,int port, int count) async {
    pingResults.value = [];
    statistics.value = "";
    for (var i = 0; i < count; i++) {
      if(state.isStart.isFalse){
        break;
      }
      final delay = await NetworkUtils.tcpPing(ip, port);
      int lastDelay = 0;
      if (pingResults.isNotEmpty) {
        lastDelay = pingResults.first.delay;
      }
      final jitter = delay - lastDelay;
      final isLoss = delay == 999;
      PingResult pingResult = PingResult(
          delay: delay, jitter: jitter, isLoss: isLoss);
      pingResults.insert(0,pingResult);
      await Future.delayed(Duration(milliseconds: 500));
    }
    count = pingResults.length;
    if(count == 0){
      return;
    }
    int lossCount = pingResults.where((pingResult) => pingResult.isLoss).toList().length;
    int maxDelay = pingResults.reduce((one, two) =>one.delay>two.delay?one:two).delay;
    int minDelay = pingResults.reduce((one, two) =>one.delay<two.delay?one:two).delay;
    int sum = pingResults.map((obj) => obj.delay).reduce((a, b) => a + b);
    double average = sum / count;
    statistics.value = '''
$ip 的 Ping 统计信息:
数据包: 已发送 = $count，已接收 = ${count-lossCount}，丢失 = $lossCount (${lossCount/count}% 丢失)，
往返行程的估计时间(以毫秒为单位):
最短 = ${minDelay}ms，最长 = ${maxDelay}ms，平均 = ${average}ms''';
    state.isStart.value = false;
  }

  void stopPing() {
    state.isStart.value = false;
  }
}
