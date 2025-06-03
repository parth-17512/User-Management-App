import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/services/api_service.dart';

import 'package:user_management_app/blocs/user_todos/user_todos_event.dart';
import 'package:user_management_app/blocs/user_todos/user_todos_state.dart';

class UserTodosBloc extends Bloc<UserTodosEvent, UserTodosState> {
  final ApiService _apiService;

  UserTodosBloc(this._apiService) : super(UserTodosInitial()) {
    on<FetchUserTodos>(_onFetchUserTodos);
  }

  Future<void> _onFetchUserTodos(
    FetchUserTodos event,
    Emitter<UserTodosState> emit,
  ) async {
    emit(UserTodosLoading());
    try {
      final todos = await _apiService.fetchUserTodos(
        event.userId,
      ); // Fetch todos from API [cite: 2]
      emit(UserTodosLoaded(todos));
    } catch (e) {
      emit(UserTodosError(e.toString()));
    }
  }
}
