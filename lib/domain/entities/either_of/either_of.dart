part 'id.dart';
part 'void_success.dart';

abstract class EitherOf<Failure, Success> {
  const EitherOf();

  T fold<T>(T Function(Failure reject) ifLeft, T Function(Success resolve) ifRight);

  Success getOrElse(Success Function() orElse) => fold((_) => orElse(), id);
}

class Left<Failure, Success> extends EitherOf<Failure, Success> {
  final Failure _failure;
  const Left(this._failure);

  @override
  T fold<T>(T Function(Failure reject) ifLeft, T Function(Success resolve) ifRight) => ifLeft(_failure);
}

class Right<Failure, Success> extends EitherOf<Failure, Success> {
  final Success _success;
  const Right(this._success);

  @override
  T fold<T>(T Function(Failure left) ifLeft, T Function(Success right) ifRight) => ifRight(_success);
}

EitherOf<Failure, Success> left<Failure, Success>(Failure value) => Left<Failure, Success>(value);
EitherOf<Failure, Success> right<Failure, Success>(Success value) => Right<Failure, Success>(value);
