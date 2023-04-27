import 'dart:ui';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final ipController = TextEditingController()..text = "";

  final portController = TextEditingController()..text = "";
  final countController = TextEditingController()..text = "";
  late BuildContext _context;

  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;
  final inputStyle = BrnFormItemConfig(
      titleTextStyle: BrnTextStyle(fontSize: 12),
      contentTextStyle: BrnTextStyle(fontSize: 12),
      hintTextStyle: BrnTextStyle(fontSize: 12),
      titlePaddingSm:EdgeInsets.zero
  );

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [_input(), _result()],
          ),
        ),
      ),
    );
  }

  _ipInput() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: BrnTextInputFormItem(
          controller: ipController,
          themeData: inputStyle,
          title: "IP",
        ),
      ),
    );
  }

  _portInput() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: BrnTextInputFormItem(
          controller: portController,
          title: "端口",
          themeData: inputStyle,
        ),
      ),
    );
  }

  _countInput() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: BrnTextInputFormItem(
          controller: countController,
          title: "次数",
          inputType: BrnInputType.number,
          themeData: inputStyle,
        ),
      ),
    );
  }

  _startBtn() {
    return Container(
      width: 66,
      height: 32,
      child: BrnNormalButton(
        text: "开始",
        alignment: Alignment.center,
        onTap: _clickStart,
        textStyle: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  _pingResultList() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: _buildPingResultItem,
          itemCount: logic.pingResults.length,
        );
      }),
    );
  }

  _statistics() {
    return Obx(() {
      return Visibility(
        visible: logic.statistics.isNotEmpty,
        child: Container(child: Text(logic.statistics.value)),
      );
    });
  }

  Widget? _buildPingResultItem(BuildContext context, int index) {
    final pingResult = logic.pingResults[index];
    String result = "请求超时";
    if (!pingResult.isLoss) {
      String delay = "延迟：${pingResult.delay.toString()}ms";
      String jitter = "抖动：${pingResult.jitter.toString()}ms";
      result =
          "第${logic.pingResults.length - index}次：来自 ${ipController.text} 的回复：$delay $jitter";
    }
    return Text(result);
  }

  void _clickStart() {
    String ip = ipController.text;
    String port = portController.text.isEmpty ? "80" : portController.text;
    String count = countController.text;
    if (!ip.isIPv4) {
      BrnToast.show("请输入正确IP地址", _context);
      return;
    }
    if (!count.isNum) {
      BrnToast.show("请输入正确次数", _context);
      return;
    }
    logic.startPing(ip, int.parse(port), int.parse(count));
  }

  _input() {
    return Container(
      child: Row(
        children: <Widget>[
          _ipInput(),
          _portInput(),
          _countInput(),
          _startBtn(),
        ],
      ),
    );
  }

  _result() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statistics(),
              _pingResultList(),
            ],
          ),
        ),
      ),
    );
  }
}
