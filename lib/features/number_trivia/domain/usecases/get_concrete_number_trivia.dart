import 'package:clean_arch_flutter/core/error/failures.dart';
import 'package:clean_arch_flutter/core/usecases/usecase.dart';
import 'package:clean_arch_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_flutter/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => throw UnimplementedError();
}