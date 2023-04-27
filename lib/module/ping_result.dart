class PingResult {
  int delay;
  int jitter;
  bool isLoss;

  PingResult(
      {required this.delay,
      required this.jitter,
      required this.isLoss});
}
