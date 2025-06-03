import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/blocs/user_list/user_list_bloc.dart';
import 'package:user_management_app/blocs/theme/theme_bloc.dart';
import 'package:user_management_app/screens/user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _debounce = Debounce(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserListBloc>().add(const FetchUsers());

    _searchController.addListener(() {
      _debounce.run(() {
        context.read<UserListBloc>().add(SearchUsers(_searchController.text));
      });
    });
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserListBloc>().add(const LoadMoreUsers());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              final isDarkMode =
                  (themeState is ThemeLoaded &&
                      themeState.themeData == ThemeData.dark());
              return IconButton(
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  context.read<ThemeBloc>().add(const ToggleTheme());
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state.message != null &&
              state.message!.isNotEmpty &&
              state.users.isEmpty) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state.users.isEmpty && state is! UserListLoading) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.users.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= state.users.length) {
                if (!state.hasReachedMax && state is UserListLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final user = state.users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    // Conditional Avatar Display based on gender or provided imageUrl
                    backgroundImage:
                        user.imageUrl.isNotEmpty
                            ? NetworkImage(user.imageUrl)
                                as ImageProvider<
                                  Object
                                >? // Cast to ImageProvider
                            : AssetImage(
                                  user.gender == 'male'
                                      ? 'assets/images/male_avatar.png'
                                      : 'assets/images/female_avatar.png',
                                )
                                as ImageProvider<
                                  Object
                                >?, // Cast to ImageProvider
                    onBackgroundImageError: (exception, stackTrace) {
                      // This error callback is for NetworkImage.
                      // For local assets, you might not need it, or handle specific fallback.
                      print('Error loading image: $exception');
                    },
                  ),
                  title: Text(user.fullName),
                  subtitle: Text(user.email),
                  trailing: Icon(
                    user.gender == 'male' ? Icons.male : Icons.female,
                    color: user.gender == 'male' ? Colors.blue : Colors.pink,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => UserDetailScreen(
                              userId: user.id,
                              userName: user.fullName,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce.dispose();
    super.dispose();
  }
}

class Debounce {
  final int milliseconds;
  VoidCallback? _action;
  Duration? _duration;
  DateTime? _lastExecution;

  Debounce({required this.milliseconds});

  run(VoidCallback action) {
    _action = action;
    _duration = Duration(milliseconds: milliseconds);
    if (_lastExecution == null ||
        DateTime.now().difference(_lastExecution!) > _duration!) {
      _lastExecution = DateTime.now();
      _action!();
    } else {
      _lastExecution = DateTime.now();
    }
  }

  void dispose() {}
}
