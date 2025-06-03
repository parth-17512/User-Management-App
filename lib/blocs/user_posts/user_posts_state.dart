// Removed: part 'user_posts_bloc.dart'; // This is incorrect

import 'package:equatable/equatable.dart';
import 'package:user_management_app/models/post.dart'; // Import Post as UserPostsLoaded uses it

abstract class UserPostsState extends Equatable {
  const UserPostsState();

  @override
  List<Object> get props => [];
}

class UserPostsInitial extends UserPostsState {}

class UserPostsLoading extends UserPostsState {}

class UserPostsLoaded extends UserPostsState {
  final List<Post> posts; // Ensure Post is imported if used here

  const UserPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class UserPostsError extends UserPostsState {
  final String message;

  const UserPostsError(this.message);

  @override
  List<Object> get props => [message];
}
