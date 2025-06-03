import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:equatable/equatable.dart'; // No longer needed here if Post is not Equatable
import 'package:user_management_app/models/post.dart';
import 'package:user_management_app/services/api_service.dart';
import 'package:user_management_app/blocs/user_posts/user_posts_state.dart'; // Import the state definitions
import 'package:user_management_app/blocs/user_posts/user_posts_event.dart'; // Import the event definitions

// Removed: part 'user_posts_event.dart'; // This is incorrect
// Removed: part 'user_posts_state.dart'; // This is incorrect

class UserPostsBloc extends Bloc<UserPostsEvent, UserPostsState> {
  final ApiService _apiService;

  UserPostsBloc(this._apiService) : super(UserPostsInitial()) {
    on<FetchUserPosts>(_onFetchUserPosts);
    on<AddLocalPost>(_onAddLocalPost);
  }

  Future<void> _onFetchUserPosts(
    FetchUserPosts event,
    Emitter<UserPostsState> emit,
  ) async {
    emit(UserPostsLoading());
    try {
      final posts = await _apiService.fetchUserPosts(event.userId);
      emit(UserPostsLoaded(posts));
    } catch (e) {
      emit(UserPostsError(e.toString()));
    }
  }

  void _onAddLocalPost(AddLocalPost event, Emitter<UserPostsState> emit) {
    if (state is UserPostsLoaded) {
      final currentPosts = List<Post>.from((state as UserPostsLoaded).posts);
      // Generate a simple local ID for the new post
      final newId =
          currentPosts.isEmpty
              ? 1
              : currentPosts.map((p) => p.id).reduce((a, b) => a > b ? a : b) +
                  1;
      final postWithId = event.post.copyWith(id: newId);
      emit(
        UserPostsLoaded([postWithId] + currentPosts),
      ); // Add new post to the top
    }
  }
}
