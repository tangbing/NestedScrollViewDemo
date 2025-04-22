

import 'package:equatable/equatable.dart';

sealed class TimerState extends Equatable {
  const TimerState(this.duration);

  final int duration;

  @override
  // TODO: implement props
  List<Object?> get props => [duration];
}

final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() {
     return 'TimerInitial {Duration: $duration}';
  }
}

final class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  String toString() {
    return 'TimerRunPause {Duration: $duration}';
  }
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  String toString() {
    return 'TimerRunInProgress {Duration: $duration}';
  }
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);


}