import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures_interface.dart';

abstract class IUseCase<Type, Params> {
  Future<Either<IFailure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [null];
}
