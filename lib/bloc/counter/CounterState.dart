// part of 'counter_bloc.dart';


import 'package:equatable/equatable.dart';

class CounterState extends Equatable {

  final int count;

  const CounterState({this.count = 0});

  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [count];


}