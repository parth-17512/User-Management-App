import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/blocs/user_detail/user_detail_bloc.dart';
import 'package:user_management_app/blocs/user_detail/user_detail_event.dart'; // ADDED: Import UserDetailEvent
import 'package:user_management_app/blocs/user_detail/user_detail_state.dart'; // ADDED: Import UserDetailState
import 'package:user_management_app/blocs/user_posts/user_posts_bloc.dart';
import 'package:user_management_app/blocs/user_posts/user_posts_event.dart'; // ADDED: Import UserPostsEvent
import 'package:user_management_app/blocs/user_posts/user_posts_state.dart'; // ADDED: Import UserPostsState
import 'package:user_management_app/blocs/user_todos/user_todos_bloc.dart';
import 'package:user_management_app/blocs/user_todos/user_todos_event.dart'; // ADDED: Import UserTodosEvent
import 'package:user_management_app/blocs/user_todos/user_todos_state.dart'; // ADDED: Import UserTodosState
import 'package:user_management_app/screens/create_post_screen.dart';
import 'package:user_management_app/models/post.dart'; // ADDED: Import Post model
//import 'package:user_management_app/models/user.dart'; // ADDED: Import User model (for UserDetailLoaded state)
//import 'package:user_management_app/models/todo.dart'; // ADDED: Import Todo model (for UserTodosLoaded state)

class UserDetailScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const UserDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch events to fetch user details, posts, and todos
    context.read<UserDetailBloc>().add(FetchUserDetails(widget.userId));
    context.read<UserPostsBloc>().add(
      FetchUserPosts(widget.userId),
    ); // Fetch user posts
    context.read<UserTodosBloc>().add(
      FetchUserTodos(widget.userId),
    ); // Fetch user todos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.userName} Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Details Section (will be managed by UserDetailBloc)
              BlocBuilder<UserDetailBloc, UserDetailState>(
                builder: (context, state) {
                  if (state is UserDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserDetailLoaded) {
                    final user = state.user;
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(user.imageUrl),
                                onBackgroundImageError: (
                                  exception,
                                  stackTrace,
                                ) {
                                  print(
                                    'Error loading detail image: $exception',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Name: ${user.fullName}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Email: ${user.email}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            // Add more user details here if available from API
                          ],
                        ),
                      ),
                    );
                  } else if (state is UserDetailError) {
                    return Center(
                      child: Text(
                        'Error loading user details: ${state.message}',
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Placeholder for initial or other states
                },
              ),

              // Posts Section (managed by UserPostsBloc)
              const Text(
                'Posts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              BlocConsumer<UserPostsBloc, UserPostsState>(
                listener: (context, state) {
                  // Listen for state changes here if you need to show snackbars etc.
                  if (state is UserPostsError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is UserPostsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserPostsLoaded) {
                    if (state.posts.isEmpty) {
                      return const Center(child: Text('No posts found.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true, // Important for nested list views
                      physics:
                          const NeverScrollableScrollPhysics(), // Important for nested list views
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(post.body),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is UserPostsError) {
                    return Center(
                      child: Text('Error loading posts: ${state.message}'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 20),

              // Todos Section (managed by UserTodosBloc)
              const Text(
                'Todos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              BlocBuilder<UserTodosBloc, UserTodosState>(
                builder: (context, state) {
                  if (state is UserTodosLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserTodosLoaded) {
                    if (state.todos.isEmpty) {
                      return const Center(child: Text('No todos found.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: CheckboxListTile(
                            title: Text(
                              todo.todo,
                              style: TextStyle(
                                decoration:
                                    todo.completed
                                        ? TextDecoration.lineThrough
                                        : null,
                              ),
                            ),
                            value: todo.completed,
                            onChanged:
                                null, // Todos are read-only from API, so no change
                          ),
                        );
                      },
                    );
                  } else if (state is UserTodosError) {
                    return Center(
                      child: Text('Error loading todos: ${state.message}'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to Create Post Screen and await result
                    final newPost = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                CreatePostScreen(userId: widget.userId),
                      ),
                    );
                    if (newPost != null && newPost is Post) {
                      // If a new post was added, dispatch an event to add it locally
                      context.read<UserPostsBloc>().add(AddLocalPost(newPost));
                    }
                  },
                  child: const Text('Add New Post'), // Create Post Screen
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
