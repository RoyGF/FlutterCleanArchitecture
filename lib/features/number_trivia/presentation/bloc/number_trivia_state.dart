import 'package:clean_arch_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaState extends Equatable {
  @override
  List<Object> get props => [];
}

class StateEmpty extends NumberTriviaState {}

class StateLoading extends NumberTriviaState {}

class StateLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  StateLoaded({@required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class StateError extends NumberTriviaState {
  final String message;

  StateError({@required this.message});

  @override
  List<Object> get props => [];
}
