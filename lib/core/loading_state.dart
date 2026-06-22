import 'package:equatable/equatable.dart';

abstract class LoadingState<T, E> extends Equatable {
  final bool isLoading;
  final T? data;
  final E? error;

  const LoadingState({this.isLoading = false, this.data, this.error});

  bool get hasData => data != null;
  bool get hasError => error != null;

  @override
  List<Object?> get props => [isLoading, data, error];

  LoadingState<T, E> copyWith({bool? isLoading, T? data, E? error});
}
