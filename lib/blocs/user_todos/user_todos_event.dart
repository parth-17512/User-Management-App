import 'package:equatable/equatable.dart';

abstract class UserTodosEvent extends Equatable {
  const UserTodosEvent();

  @override
  List<Object> get props => [];
}

class FetchUserTodos extends UserTodosEvent {
  final int userId;

  const FetchUserTodos(this.userId);

  @override
  List<Object> get props => [userId];
}
