import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_management_app/models/user.dart';
import 'package:user_management_app/services/api_service.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final ApiService _apiService;
  final int _limit = 10;
  int _skip = 0;
  String _currentSearchTerm = '';

  UserListBloc(this._apiService) : super(const UserListInitial()) {
    // Initialize with const UserListInitial
    on<FetchUsers>(_onFetchUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UserListState> emit,
  ) async {
    // Keep existing users if not initial load
    final currentUsers = state.users;
    emit(
      UserListLoading(users: currentUsers),
    ); // Indicate loading state, keeping existing users
    _skip = 0;
    _currentSearchTerm = '';
    try {
      final users = await _apiService.fetchUsers(limit: _limit, skip: _skip);
      emit(UserListLoaded(users: users, hasReachedMax: users.length < _limit));
    } catch (e) {
      emit(
        UserListError(e.toString(), users: currentUsers),
      ); // Emit error, keeping existing users
    }
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserListState> emit,
  ) async {
    if (state.hasReachedMax) return; // Stop if all users are loaded

    final currentUsers = state.users;
    emit(
      UserListLoading(users: currentUsers, hasReachedMax: state.hasReachedMax),
    ); // Indicate loading more

    _skip += _limit;
    try {
      final newUsers = await _apiService.fetchUsers(
        limit: _limit,
        skip: _skip,
        searchTerm: _currentSearchTerm,
      );
      emit(
        UserListLoaded(
          users: currentUsers + newUsers, // Append new users
          hasReachedMax: newUsers.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        UserListError(
          "Failed to load more users: ${e.toString()}",
          users: currentUsers,
          hasReachedMax: state.hasReachedMax,
        ),
      );
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserListState> emit,
  ) async {
    _currentSearchTerm = event.searchTerm;
    emit(
      UserListLoading(),
    ); // For search, typically clear current users and show fresh loading
    _skip = 0;
    try {
      final users = await _apiService.fetchUsers(
        limit: _limit,
        skip: _skip,
        searchTerm: _currentSearchTerm,
      );
      emit(UserListLoaded(users: users, hasReachedMax: users.length < _limit));
    } catch (e) {
      emit(UserListError(e.toString())); // Error for search
    }
  }
}
