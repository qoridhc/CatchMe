import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final TimerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(0);

  bool isRun = false;
  int defaultTime = 900;

  late StreamSubscription<int> _stream;

  @override
  set state(int value) {
    super.state = value;
  }

  void start() {
    isRun = true;

    _stream = Stream.periodic(Duration(seconds: 1), (x) => x).listen(
      (x) {
        if (mounted) {
          state = defaultTime - x;
        }
        if(state == 0){
          pause();
        }
      },
    );
  }

  void pause() {
    _stream.pause();
    isRun = false;
  }

  void restart() {
    _stream.resume();
  }

  void cancel() {
    _stream.cancel();
    state = 0;
    isRun = false;
  }
}
