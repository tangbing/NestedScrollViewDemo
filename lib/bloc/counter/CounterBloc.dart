


import 'package:bloc/bloc.dart';

import 'CounterState.dart';
import 'counter_bloc.dart';


// import 'package:first_project/bloc/counter_bloc.dart';

// part 'counter_event.dart';
// part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<IncrementEvent>(_onIncrement);
    on<DecrementEvent>(_onDecrement);
  }

  void _onIncrement(IncrementEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(count: state.count + 1));
  }

  void _onDecrement(DecrementEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(count: state.count - 1));
  }


}