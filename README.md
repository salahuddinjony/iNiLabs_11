# inilab

A GitHub repository viewer Flutter application with authentic GitHub design and theme.

## Features

- 🎨 GitHub-authentic light and dark themes
- 📊 Real-time contribution calendar
- 🔍 Repository browsing and search
- 📱 Responsive design with flutter_screenutil
- 🧭 Go Router navigation
- 🌙 Theme switching

## Getting Started

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
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Give it a name and select the following scopes:
     - `read:user` - Read user profile data
     - `repo` - Access repository data
   - Click "Generate token"
   - Copy the token and paste it in your `.env` file

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── app.dart                      # Main app configuration
├── main.dart                     # Entry point
├── core/
│   ├── constants/               # App constants
│   ├── routes/                  # Go Router configuration
│   ├── theme/                   # GitHub-authentic themes
│   └── utils/                   # Utilities
├── data/
│   ├── models/                  # Data models
│   └── repositories/            # Repository layer
├── features/
│   └── screen/splash/           # Splash screen
└── presentation/
    ├── controllers/             # GetX controllers
    ├── screens/                 # App screens
    └── widgets/                 # Reusable widgets
```

## Technologies Used

- **Flutter** - UI framework
- **GetX** - State management
- **Go Router** - Declarative routing
- **flutter_screenutil** - Responsive UI
- **flutter_dotenv** - Environment variables
- **Dio** - HTTP client for GitHub API
- **cached_network_image** - Image caching

## Security Note

⚠️ **Important:** Never commit your `.env` file to version control. It's already added to `.gitignore` to prevent accidental commits. Always use `.env.example` as a template for other developers.

## License

This project is for educational purposes.
