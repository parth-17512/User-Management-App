import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/blocs/user_detail/user_detail_state.dart';
import 'package:user_management_app/services/api_service.dart';

import 'package:user_management_app/blocs/user_detail/user_detail_event.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final ApiService _apiService;

  UserDetailBloc(this._apiService) : super(UserDetailInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());
    try {
      // DummyJSON API doesn't have a direct /users/{id} endpoint for a single user,
      // but you can fetch all users and filter, or assume the user object is passed
      // from the previous screen. For simplicity, we'll fetch all and find,
      // or if you only need the user object, you'd ideally pass it from the list screen.
      // For this example, we'll assume we can fetch the user by ID (which is not directly supported by dummyjson for a single user,
      // so this is a simplified workaround for illustration):
      final users = await _apiService.fetchUsers(
        limit: 100,
      ); // Fetch a larger set to find the user
      final user = users.firstWhere(
        (u) => u.id == event.userId,
        orElse: () => throw Exception('User not found'),
      );
      emit(UserDetailLoaded(user));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }
}
