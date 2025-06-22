import 'package:flut1/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<AppFailure, T>>;
typedef FutureVoid = FutureEither<void>;
