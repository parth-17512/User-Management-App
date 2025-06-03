import 'package:equatable/equatable.dart';
import 'package:user_management_app/models/todo.dart';

abstract class UserTodosState extends Equatable {
  const UserTodosState();

  @override
  List<Object> get props => [];
}

class UserTodosInitial extends UserTodosState {}

class UserTodosLoading extends UserTodosState {}

class UserTodosLoaded extends UserTodosState {
  final List<Todo> todos;

  const UserTodosLoaded(this.todos);

  @override
  List<Object> get props => [todos];
}

class UserTodosError extends UserTodosState {
  final String message;

  const UserTodosError(this.message);

  @override
  List<Object> get props => [message];
}
