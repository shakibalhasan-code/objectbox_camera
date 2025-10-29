# ObjectBox Camera CRUD Flutter Application

A Flutter application that demonstrates CRUD operations using ObjectBox database for video recording and management. The app allows users to record videos using device camera, store them locally with ObjectBox, and perform basic CRUD operations.

## Features

- Video recording using device camera
- Local video storage and playback
- CRUD operations (Create, Read, Update, Delete)
- Video metadata management (title, path, duration, creation date)
- Clean architecture with separation of concerns
- State management using GetX

## Architecture

The application follows a modular clean architecture pattern with clear separation between data, business logic, and presentation layers.

### Project Structure

```
lib/
├── main.dart                           # Application entry point
├── objectbox.g.dart                    # ObjectBox generated file
├── objectbox-model.json               # ObjectBox model schema
└── modules/
    ├── app.dart                        # Root application widget
    ├── core/                           # Core business logic and data layer
    │   ├── config/
    │   │   └── app_bindings.dart       # GetX dependency injection
    │   ├── controllers/
    │   │   ├── home_controller.dart    # Home screen state management
    │   │   └── video_record_controller.dart # Video recording logic
    │   ├── db/
    │   │   └── objectbox_helper.dart   # Database helper and operations
    │   ├── models/
    │   │   └── video_entity.dart       # Video data model
    │   └── repo/
    │       └── video_repo.dart         # Data repository layer
    ├── screens/
    │   └── video_recording_screen.dart # Legacy screen location
    └── views/
        ├── screens/
        │   ├── home_screen.dart        # Main screen with video list
        │   └── video_recording_screen.dart # Video recording interface
        └── widgets/
            └── custom_video_player.dart # Reusable video player component
```

## Core Components

### Database Layer
- **ObjectBox Helper** (`core/db/objectbox_helper.dart`): Manages database operations and provides generic CRUD methods
- **Video Entity** (`core/models/video_entity.dart`): Data model for video records with ObjectBox annotations
- **Video Repository** (`core/repo/video_repo.dart`): Abstraction layer for video data operations

### Business Logic Layer
- **Home Controller** (`core/controllers/home_controller.dart`): Manages video list state and operations
- **Video Record Controller** (`core/controllers/video_record_controller.dart`): Handles camera initialization, video recording, and playback

### Presentation Layer
- **Home Screen** (`views/screens/home_screen.dart`): Displays video list with CRUD operations
- **Video Recording Screen** (`views/screens/video_recording_screen.dart`): Camera interface for recording videos
- **Custom Video Player** (`views/widgets/custom_video_player.dart`): Reusable video playback component

### Configuration
- **App Bindings** (`core/config/app_bindings.dart`): Dependency injection setup for controllers and repositories

## Dependencies

### Core Dependencies
- `flutter`: Flutter framework
- `get: ^4.7.2`: State management and dependency injection
- `objectbox: ^5.0.1`: NoSQL database for Flutter
- `objectbox_flutter_libs: ^5.0.1`: ObjectBox platform libraries

### Media Dependencies
- `camera: ^0.11.2+1`: Camera functionality for video recording
- `video_player: ^2.10.0`: Video playback capabilities
- `path_provider: ^2.1.5`: File system path access

### Development Dependencies
- `build_runner: ^2.4.9`: Code generation runner
- `objectbox_generator: 5.0.1`: ObjectBox code generation
- `flutter_lints: ^5.0.0`: Linting rules

## Key Features Implementation

### Video Recording
- Camera initialization and configuration
- Real-time video recording with start/stop controls
- Video file management and storage

### Database Operations
- Create: Save new video records with metadata
- Read: Fetch and display video lists
- Update: Modify video information
- Delete: Remove videos from database and storage

### State Management
- Reactive UI updates using GetX observables
- Controller-based architecture for business logic
- Dependency injection for loose coupling

## File Structure Details

### Core Module (`lib/modules/core/`)
Contains the business logic and data management components:
- **Config**: Dependency injection and app configuration
- **Controllers**: State management and business logic
- **DB**: Database helper and ObjectBox integration
- **Models**: Data entities and domain objects
- **Repo**: Data access layer and repository pattern

### Views Module (`lib/modules/views/`)
Contains the presentation layer components:
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components

### Platform Support
The application supports multiple platforms with dedicated configuration:
- **Android**: Native Android configuration and build files
- **iOS**: iOS project configuration and settings
- **Windows**: Windows desktop support
- **Linux**: Linux desktop support
- **macOS**: macOS desktop support
- **Web**: Web platform support

## Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Platform-specific development tools (Android Studio, Xcode, etc.)

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter packages pub run build_runner build` to generate ObjectBox files
4. Run the application using `flutter run`

### Build Process
The application uses build_runner for code generation, particularly for ObjectBox database schema generation. The generated files include:
- `objectbox.g.dart`: Generated ObjectBox database code
- Platform-specific build configurations

## Development Notes

### ObjectBox Integration
The application uses ObjectBox as a NoSQL database for local data storage. The database is initialized in `main.dart` and accessed through a helper class that provides generic CRUD operations.

### State Management
GetX is used for state management, providing reactive programming capabilities and dependency injection. Controllers manage the business logic while views remain stateless and reactive to state changes.

### Camera Integration
The camera functionality is implemented using the Flutter camera plugin with proper lifecycle management and error handling for video recording operations.

## Error Handling
The application includes comprehensive error handling for:
- Camera initialization failures
- Video recording errors
- Database operation exceptions
- File system access issues

All errors are displayed to users through GetX snackbars for better user experience.
