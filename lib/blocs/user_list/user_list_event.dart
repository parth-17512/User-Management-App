part of 'user_list_bloc.dart';

abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch the initial list of users or refresh [cite: 2]
class FetchUsers extends UserListEvent {
  const FetchUsers();
}

// Event to load more users (for infinite scrolling) [cite: 2]
class LoadMoreUsers extends UserListEvent {
  const LoadMoreUsers();
}

// Event to search for users by name [cite: 2]
class SearchUsers extends UserListEvent {
  final String searchTerm;

  const SearchUsers(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}
