// part of 'counter_block.dart';

import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

