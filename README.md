<br>This is a Flutter application built as an internship assessment task for a Flutter Developer position. It focuses on user management, demonstrating key mobile development concepts such as API integration, state management using the BLoC pattern, and adherence to clean code principles.

<br>Table of Contents
<br>Project Overview
<br>Features
<br>Technical Stack & Architecture
<br>Setup Instructions
<br>Usage
<br>Bonus Features (Implemented)
<br>Submission Details
<br>Resources
<h3>Project Overview</h3>
<br>The primary objective of this project is to create a robust Flutter application that manages user data. The app interacts with a third-party API to fetch user information, including their posts and to-dos. It implements common UI/UX patterns like infinite scrolling and search, all while maintaining a clean and scalable architecture using the BLoC state management pattern.

<h3>Features</h3>
<br>The application includes the following core functionalities:

<br>API Integration: Fetches user data, posts, and todos from DummyJSON API. 
<br>User List: https://dummyjson.com/users 
<br>User Posts: https://dummyjson.com/posts/user/{userId} 
<br>User Todos: https://dummyjson.com/todos/user/{userId} 
<br>Pagination & Infinite Scrolling: Loads users in chunks with limit/skip parameters and supports infinite scrolling on the user list.
<br>Search Functionality: Allows real-time searching of users by name.
<br>BLoC State Management: Utilizes flutter_bloc to manage app states (loading, success, error) for data fetching and UI updates.
<br>User List Screen: Displays users with their avatar, full name, and email. Includes a search bar at the top.
<br>User Detail Screen: Shows comprehensive user information, along with their associated posts and to-dos.
<br>Create Post Screen: Allows adding new posts locally (title + body) which are displayed instantly for the selected user. (Note: These posts are not persisted to the API).
<br>Loading Indicators: Visual cues (e.g., circular progress indicators) are shown during API calls.
<br>Error Handling: Appropriate error messages are displayed to the user when API calls fail.
<br>Gender Icons: Displays a male or female icon based on the user's gender.
<br>Technical Stack & Architecture
<br>Framework: Flutter
<br>Language: Dart
<br>State Management: BLoC (flutter_bloc package)
<br>HTTP Client: Dio (dio package)
<br>Architecture: The project follows a layered architecture, separating concerns into:
<br>models: Data structures (e.g., User, Post, Todo).
<br>services: Handles API interactions (ApiService).
<br>blocs: Contains the business logic and state management for different features (e.g., UserListBloc, UserDetailBloc, UserPostsBloc, UserTodosBloc, ThemeBloc).
<br>screens: Houses the UI components and consumes BLoC states. This separation enhances code readability, maintainability, and testability.

<b>In the screenshot folder, the video and screenshot is provided for this project.</b>
