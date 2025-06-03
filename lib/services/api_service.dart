import 'package:dio/dio.dart';
import 'package:user_management_app/models/user.dart'; // We will create this model next
import 'package:user_management_app/models/post.dart'; // We will create this model next
import 'package:user_management_app/models/todo.dart'; // We will create this model next

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl =
      'https://dummyjson.com'; // Base URL for DummyJSON API [cite: 2]

  // Fetch a list of users with pagination and search
  Future<List<User>> fetchUsers({
    int limit = 10,
    int skip = 0,
    String? searchTerm,
  }) async {
    try {
      String path = '$_baseUrl/users';
      final Map<String, dynamic> queryParameters = {
        'limit': limit,
        'skip': skip,
      };

      if (searchTerm != null && searchTerm.isNotEmpty) {
        path = '$_baseUrl/users/search';
        queryParameters['q'] =
            searchTerm; // Search by 'q' parameter for users [cite: 2]
      }

      final response = await _dio.get(path, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> userJson =
            response
                .data['users']; // The API returns users under a 'users' key [cite: 2]
        return userJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // Fetch posts for a specific user [cite: 2]
  Future<List<Post>> fetchUserPosts(int userId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/posts/user/$userId',
      ); // Fetch posts by user ID [cite: 2]
      if (response.statusCode == 200) {
        final List<dynamic> postJson =
            response
                .data['posts']; // The API returns posts under a 'posts' key [cite: 2]
        return postJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  // Fetch todos for a specific user [cite: 2]
  Future<List<Todo>> fetchUserTodos(int userId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/todos/user/$userId',
      ); // Fetch todos by user ID [cite: 2]
      if (response.statusCode == 200) {
        final List<dynamic> todoJson =
            response
                .data['todos']; // The API returns todos under a 'todos' key [cite: 2]
        return todoJson.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }
}
