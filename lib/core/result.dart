sealed class Result<T, E> {
  const Result();

  factory Result.success(T data) = Success<T, E>;
  factory Result.failure(E error) = Failure<T, E>;

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;
}

class Success<T, E> extends Result<T, E> {
  final T data;
  const Success(this.data);
}

class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}
