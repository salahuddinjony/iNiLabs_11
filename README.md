# GitHub Repository Finder

A feature-rich GitHub repository viewer built with Flutter, featuring an authentic GitHub design, comprehensive user profiles, and advanced navigation capabilities.

## ✨ Features

### 🔐 Authentication & User Management
- **Persistent Login** - User credentials saved locally using SharedPreferences
- **Automatic Session** - Auto-login on app restart for seamless experience
- **Secure Token Storage** - GitHub Personal Access Token stored in environment variables

### 📊 User Profile & Statistics
- **Complete User Info** - View username, bio, avatar, and public repository count
- **Contribution Activity** - Real-time contribution calendar powered by GitHub GraphQL API
- **Social Connections** - View followers and following lists with pagination (100 users per page)
- **Profile Navigation** - Click on any user to view their complete profile and repositories

### � Repository Management
- **Repository Listing** - Browse all public repositories of any GitHub user
- **Advanced Search** - Real-time search through repositories by name or description
- **Multiple Views** - Switch between list and grid layouts
- **Smart Sorting** - Sort by name, creation date, stars, or last updated
- **Repository Details** - View complete repository information
- **GitHub Integration** - Direct link to open repositories on GitHub

### 🎨 UI/UX Excellence
- **GitHub-Authentic Themes** - Professionally designed light and dark modes
- **Persistent Theme** - Theme preference saved locally and applied app-wide
- **Smooth Transitions** - No theme flicker on app startup
- **Responsive Design** - Optimized for all screen sizes with flutter_screenutil
- **Infinite Scroll** - Paginated loading for followers/following lists

### 🧭 Navigation
- **Go Router** - Declarative routing with clean URL handling
- **Smart Navigation** - Dynamic back button when viewing other user profiles
- **Quick Access** - Home button in user lists to return to main profile
- **Deep Linking** - Proper route management for complex navigation flows

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd iNiLabs_11
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   
   Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add your GitHub Personal Access Token:
   ```
   GITHUB_TOKEN=your_github_personal_access_token_here
   ```

   **How to get a GitHub Personal Access Token:**
   - Go to [GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)](https://github.com/settings/tokens)
   - Click "Generate new token (classic)"
   - Give it a descriptive name (e.g., "Flutter Repo Finder")
   - Select the following scopes:
     - `read:user` - Read user profile data
     - `repo` - Access repository data (for contribution activity)
   - Click "Generate token"
   - Copy the token and paste it in your `.env` file

   ⚠️ **Important:** Keep your token secure and never share it publicly!

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Flow

1. **Splash Screen** - Animated splash with theme-aware design
2. **Login Screen** - Enter any GitHub username to explore
3. **Home Screen** - View user profile, contributions, and repositories
4. **User Lists** - Browse followers/following with infinite scroll
5. **Profile Navigation** - Explore other users' profiles seamlessly
6. **Repository Details** - View complete repository information

## 🏗️ Project Structure

```
lib/
├── app.dart                      # Main app configuration with theme setup
├── main.dart                     # Entry point with initialization
├── helper/
│   └── initialize_app.dart      # App initialization logic
├── core/
│   ├── bindings/                # Dependency injection
│   ├── constants/               # API and app constants
│   ├── enums/                   # Enum definitions (UserListType)
│   ├── routes/                  # Go Router configuration
│   ├── theme/                   # GitHub-authentic light/dark themes
│   └── utils/                   # API service and utilities
├── data/
│   ├── models/                  # Data models (GithubUser, GithubRepository)
│   └── repositories/            # Repository layer for API calls
├── presentation/
│   ├── controllers/             # GetX state management controllers
│   │   ├── theme_controller.dart
│   │   ├── login_controller.dart
│   │   ├── home_controller.dart
│   │   └── user_list_controller.dart
│   ├── screens/                 # App screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── user_list_screen.dart
│   │   └── repository_details_screen.dart
│   └── widgets/                 # Reusable widgets
│       ├── contribution_chart.dart
│       ├── repository_card.dart
│       ├── user_avatar.dart
│       └── ...
└── features/
    └── screen/splash/           # Legacy splash screen location
```

## 🛠️ Technologies Used

### Core Framework
- **Flutter 3.35.7** - UI framework
- **Dart 3.9.2** - Programming language

### State Management & Navigation
- **GetX** - Reactive state management and dependency injection
- **Go Router 14.6.2** - Declarative routing and navigation

### API & Networking
- **Dio** - HTTP client for GitHub REST API
- **GitHub GraphQL API** - Contribution activity data
- **flutter_dotenv** - Secure environment variable management

### UI & Design
- **flutter_screenutil 5.9.3** - Responsive layout
- **cached_network_image** - Efficient image loading and caching
- **flutter_easyloading** - User-friendly loading indicators

### Local Storage
- **SharedPreferences** - Persistent storage for user credentials and theme preferences

## 🔑 API Integration

This app integrates with GitHub using two methods:

1. **REST API** - User data, repositories, followers, following
2. **GraphQL API** - Contribution activity calendar

Both require authentication via Personal Access Token for higher rate limits and access to detailed data.

## 📲 Key Features Walkthrough

### User Authentication
- Enter any GitHub username to start exploring
- Your login is automatically saved for future sessions
- Logout option available in the main profile

### Repository Browsing
- View all public repositories in list or grid layout
- Use the search bar to filter repositories by name or description
- Sort repositories by:
  - Recently Updated (default)
  - Name (alphabetical)
  - Creation Date
  - Star Count
- Click any repository to view details
- Open repositories directly on GitHub with one tap

### Social Features
- Click on follower/following counts to view lists
- Paginated loading (100 users per page) with infinite scroll
- Click any user in the list to view their profile
- Navigate through multiple user profiles seamlessly
- Use the home button to return to your main profile anytime

### Contribution Activity
- Visual contribution calendar powered by GitHub GraphQL
- Shows your coding activity over time
- Authentic GitHub-style design

### Theme Management
- Toggle between light and dark modes from any screen
- Theme preference is saved locally
- Consistent theme across all screens including splash

## 🎯 Architecture & Design Patterns

- **MVC Pattern** - Clear separation of concerns
- **Repository Pattern** - Abstracted data layer
- **Dependency Injection** - GetX-based DI for controllers
- **Reactive Programming** - GetX observables for state management
- **Clean Code** - Well-organized, maintainable codebase

## 🔒 Security Best Practices

✅ Environment variables for sensitive data  
✅ .env file excluded from version control  
✅ Secure token storage  
✅ No hardcoded credentials  
✅ .env.example template for developers

## 📝 Future Enhancements

- [ ] Repository starring/unstarring
- [ ] Issue browsing and management
- [ ] Pull request viewing
- [ ] Code browsing
- [ ] Multiple account support
- [ ] Offline mode with caching

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is for educational purposes.

## 👨‍💻 Developer

Built with ❤️ using Flutter

---

**Note:** This is an unofficial GitHub client and is not affiliated with GitHub, Inc.
