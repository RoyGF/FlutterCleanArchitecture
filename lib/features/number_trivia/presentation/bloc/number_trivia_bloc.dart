import 'package:clean_arch_flutter/core/error/failures.dart';
import 'package:clean_arch_flutter/core/usecases/usecase.dart';
import 'package:clean_arch_flutter/core/util/input_converter.dart';
import 'package:clean_arch_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_flutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_flutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch_flutter/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => StateEmpty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is EventGetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield StateError(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield StateLoading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is EventGetTriviaForRandomNumber) {
      yield StateLoading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (failure) => StateError(message: _mapFailureToMessage(failure)),
      (trivia) => StateLoaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
