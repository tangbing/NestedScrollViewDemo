


import 'package:first_project/bloc/counter/CounterBloc.dart';
import 'package:first_project/bloc/counter/CounterState.dart';
import 'package:first_project/bloc/counter/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Counter'),
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(builder: (context, state) {
         return Text('Count: ${state.count}');
        }),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
              onPressed: () => context.read<CounterBloc>().add(IncrementEvent()),
              child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(DecrementEvent()),
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
