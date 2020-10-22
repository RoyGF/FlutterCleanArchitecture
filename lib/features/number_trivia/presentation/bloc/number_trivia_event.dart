import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EventGetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  EventGetTriviaForConcreteNumber({@required this.numberString});

  @override
  List<Object> get props => [numberString];
}

class EventGetTriviaForRandomNumber extends NumberTriviaEvent {}
