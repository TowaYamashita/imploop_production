import 'package:stop_watch_timer/stop_watch_timer.dart';

class TodoTimer {
  static TodoTimer? _instance;

  factory TodoTimer(StopWatchTimer stopWatchTimer) {
    _instance ??= TodoTimer._(stopWatchTimer: stopWatchTimer);
    return _instance!;
  }

  const TodoTimer._({
    required this.stopWatchTimer,
  });
  final StopWatchTimer stopWatchTimer;

  /// タイマーを開始させる
  void start() {
    return stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  /// タイマーを一時停止させる
  void pause() {
    if (_isRunningTimer()) {
      return stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    }
  }

  /// タイマーを再開させる
  void resume() {
    if (!_isRunningTimer()) {
      return stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
  }

  /// タイマーを停止させる
  void stop() {
    return stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  }

  /// タイマーの値を初期化させる
  void reset() {
    return stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }

  /// タイマーの経過時間[分]を取得する
  /// 
  /// 分以下は四捨五入する
  /// 
  /// このメソッドを実行する際にタイマーが動いていれば停止させる
  int elapsedMinutes() {
    if (_isRunningTimer()) {
      stop();
    }
    final int elpasedTime = stopWatchTimer.rawTime.value;
    return (elpasedTime / (60 * 1000)).round();
  }

  /// タイマーが動いているかどうか判定する
  /// 
  /// 動いていればtrue、そうでなければfalseを返す
  bool _isRunningTimer() {
    return stopWatchTimer.isRunning;
  }
}
