// Removed: part of 'user_posts_bloc.dart'; // This is incorrect
import 'package:equatable/equatable.dart';
import 'package:user_management_app/models/post.dart'; // Import Post if AddLocalPost uses it

abstract class UserPostsEvent extends Equatable {
  const UserPostsEvent();

  @override
  List<Object> get props => [];
}

class FetchUserPosts extends UserPostsEvent {
  final int userId;

  const FetchUserPosts(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddLocalPost extends UserPostsEvent {
  final Post post;

  const AddLocalPost(this.post);

  @override
  List<Object> get props => [post];
}
