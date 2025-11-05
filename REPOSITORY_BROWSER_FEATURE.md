# Repository Browser Feature

## Overview
This feature allows users to browse repository files and folders directly in the app, view file contents with syntax highlighting, download repositories as ZIP files, and copy clone URLs - just like GitHub!

## Features

### 📁 Repository Browser
- **File & Folder Navigation**: Browse through repository directory structure
- **Breadcrumb Navigation**: See your current location in the repository
- **Smart Sorting**: Directories appear first, then files, all sorted alphabetically
- **File Type Icons**: Visual indicators for different file types (code, images, documents, etc.)
- **File Size Display**: Shows human-readable file sizes
- **Pull to Refresh**: Refresh directory contents

### 📄 File Viewer
- **Syntax-Aware Display**: Monospace font for code files
- **Line Numbers**: Toggle line numbers on/off for better code reading
- **Selectable Text**: Select and copy any portion of the code
- **Copy Content**: One-tap copy entire file content to clipboard
- **Open on GitHub**: Direct link to view file on GitHub
- **File Info**: Display file size and line count

### 📥 Download & Share
- **Download ZIP**: Download entire repository as ZIP file
- **Copy Clone URL**: Copy repository URL to clipboard with confirmation
- **GitHub Integration**: Open repository or files directly on GitHub

### 🎨 Clean Code Architecture
- **Reusable Components**: 
  - `RepositoryBrowserController` - Handles all repository browsing logic
  - `RepositoryContent` & `FileContent` models - Clean data structures
  - Separate screens for browser and file viewer
  
- **GraphQL API Integration**: Uses the same GitHub token and API pattern as `ContributionChartController`

## File Structure

```
lib/
├── data/
│   └── models/
│       └── repository_content.dart          # Models for files and folders
├── presentation/
│   ├── controllers/
│   │   └── repository_browser_controller.dart  # Browser logic
│   ├── screens/
│   │   ├── repository_browser_screen.dart   # File/folder browser UI
│   │   └── file_viewer_screen.dart          # File content viewer UI
│   └── widgets/
│       ├── repository_card.dart             # Updated with Browse button
│       └── repository_grid_item.dart        # Updated with Browse button
└── core/
    └── routes/
        ├── route_path.dart                   # Added new routes
        └── app_router.dart                   # Configured new screens
```

## Usage Flow

1. **From Home Screen**:
   - Click the folder icon on any repository card
   - OR click on repository → Click "Browse Files" button

2. **In Repository Browser**:
   - Click folders to navigate deeper
   - Click files to view their content
   - Use back button to go up one level
   - Download ZIP from top-right menu
   - Copy clone URL from top-right menu

3. **In File Viewer**:
   - Toggle line numbers with the button
   - Copy content with copy button
   - Open on GitHub with browser button
   - Switch theme as needed

## Technical Details

### API Integration
- Uses GitHub REST API v3 for file browsing
- Endpoints:
  - `GET /repos/{owner}/{repo}/contents/{path}` - List directory contents
  - `GET /repos/{owner}/{repo}/contents/{path}` - Get file content (base64 encoded)
  
### Authentication
- Uses the same `GITHUB_TOKEN` from `.env` file
- Token is shared across all GraphQL/REST API calls

### State Management
- GetX for reactive state management
- Separate controller instances per repository using tags
- Proper cleanup on navigation

### Error Handling
- Network error handling with user-friendly messages
- Empty state displays for empty directories
- Retry mechanisms for failed requests

## Quick Access Features

### Repository Cards (List & Grid View)
- Added folder icon button for quick access to file browser
- Maintains existing click behavior for repository details
- Consistent design across both view types

### Repository Details Screen
- Primary "Browse Files" button (filled style)
- Secondary "View on GitHub" button (outlined style)
- Clear visual hierarchy

## UX Enhancements

1. **Visual Feedback**:
   - Loading indicators during API calls
   - Success messages on copy actions
   - Error states with retry options

2. **Navigation**:
   - Breadcrumb path showing current location
   - Back button returns to previous directory
   - Consistent app-wide navigation patterns

3. **Theming**:
   - Full dark/light mode support
   - Theme toggle available in all screens
   - Consistent with app-wide theme

## Example Usage in Code

### Navigate to Repository Browser
```dart
context.pushNamed(
  RoutePath.repositoryBrowser,
  extra: repository,
);
```

### Navigate to File Viewer
```dart
context.pushNamed(
  RoutePath.fileViewer,
  extra: {
    'controller': controller,
    'filePath': 'path/to/file.dart',
    'fileName': 'file.dart',
  },
);
```

## Supported File Types

### Code Files
- Dart, Java, Kotlin, Swift, C/C++, Python, JavaScript, TypeScript

### Data Files
- JSON, XML, HTML

### Documents
- Markdown, Text files, PDF

### Media
- Images (PNG, JPG, GIF, SVG)

### Archives
- ZIP, TAR, GZ

## Performance Considerations

1. **Lazy Loading**: Only loads current directory contents
2. **Efficient Decoding**: Base64 content decoded on-demand
3. **Memory Management**: Controllers properly disposed when not needed
4. **Caching**: GetX controller tags prevent duplicate instances

## Future Enhancements (Optional)

- [ ] Syntax highlighting for different languages
- [ ] Search within files
- [ ] Recent files history
- [ ] Favorite files/folders
- [ ] Diff view for comparing versions
- [ ] Commit history for files

## Testing Recommendations

1. Test with repositories of different sizes
2. Test with empty repositories
3. Test with binary files
4. Test network error scenarios
5. Test deep folder structures
6. Test theme switching in all screens
