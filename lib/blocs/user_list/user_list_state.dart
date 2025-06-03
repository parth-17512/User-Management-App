part of 'user_list_bloc.dart';

abstract class UserListState extends Equatable {
  final List<User> users; // All states will now have a list of users
  final String? message; // All states can now have an optional error message
  final bool hasReachedMax; // All states will now have this property

  const UserListState({
    this.users = const [], // Default to empty list
    this.message,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [users, message, hasReachedMax];
}

// Initial state, before any data is loaded
class UserListInitial extends UserListState {
  const UserListInitial({super.users, super.message, super.hasReachedMax});
}

// State when users are being loaded
class UserListLoading extends UserListState {
  const UserListLoading({
    super.users, // Can still carry existing users while loading more
    super.message,
    super.hasReachedMax,
  });
}

// State when users are successfully loaded
class UserListLoaded extends UserListState {
  // No need for explicit properties here, they are in the base class
  const UserListLoaded({
    required super.users, // This state specifically ensures users are loaded
    super.message,
    super.hasReachedMax = false,
  });

  UserListLoaded copyWith({
    List<User>? users,
    String? message,
    bool? hasReachedMax,
  }) {
    return UserListLoaded(
      users: users ?? this.users,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [users, message, hasReachedMax];
}

// State when there's an error loading users
class UserListError extends UserListState {
  const UserListError(
    String message, {
    super.users, // Can still carry existing users during an error
    super.hasReachedMax,
  }) : super(message: message);

  @override
  List<Object?> get props => [users, message, hasReachedMax];
}
