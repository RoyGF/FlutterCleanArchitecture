import 'package:clean_arch_flutter/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_arch_flutter/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is StateEmpty) {
                    return MessageDisplay(message: 'Start searching!');
                  } else if (state is StateLoading) {
                    return LoadingWidget();
                  } else if (state is StateLoaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is StateError) {
                    return MessageDisplay(message: state.message);
                  }
                },
              ),
              SizedBox(height: 20),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
