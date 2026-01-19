# Local Notes App

A minimal Flutter notes application demonstrating real-world architecture patterns: offline-first data management, reactive UI, and the repository pattern.

## Overview

This is a **learning project** designed to bridge the gap between Flutter syntax and professional architecture. It prioritizes clean separation of concerns and async-first patterns over UI polish.

### Key Features

- **Create, read, update, and delete notes** with a simple, responsive UI
- **Offline-first storage** using SQLite for persistence across app restarts
- **Reactive UI** with Provider for state management
- **Repository pattern** to decouple business logic from UI
- **Clean async handling** using `Future` and `await`

## Architecture

The app follows a **layered architecture** mirroring Unity service layers:

```
┌─────────────────────┐
│   UI Widgets        │  (EditNotePage, NotesListPage)
│  (Stateful/less)    │  Dumb; only read state and dispatch actions
└──────────┬──────────┘
           │ context.watch() / context.read()
           ↓
┌─────────────────────┐
│  NotesController    │  (State Manager via Provider)
│  (ChangeNotifier)   │  Holds UI state; coordinates repo calls
└──────────┬──────────┘
           │ await repo.addNote()
           ↓
┌─────────────────────┐
│  NotesRepository    │  (Data Layer)
│  (SQLite wrapper)   │  All DB logic; returns Note objects
└──────────┬──────────┘
           │ sqflite
           ↓
┌─────────────────────┐
│   SQLite Database   │  Persisted locally on device
└─────────────────────┘
```

### Data Model

**Note** (`lib/models/note.dart`)
- `id`: Unique identifier (auto-increment)
- `title`: Note heading
- `content`: Note body
- `createdAt`: Timestamp when created
- `updatedAt`: Timestamp of last modification

### State Management

**NotesController** (`lib/controllers/notes_controller.dart`)
- Extends `ChangeNotifier` for reactive updates
- Maintains in-memory list of notes
- Public methods: `addNote()`, `updateNote()`, `deleteNote()`, `initializeNote()`
- Calls `notifyListeners()` after each mutation so UI rebuilds

### Data Persistence

**NotesRepository** (`lib/data/notes_repository.dart`)
- Initializes SQLite on app launch
- CRUD operations: `getAllNotes()`, `addNote()`, `updateNote()`, `deleteNote()`
- Handles all `sqflite` interactions
- Returns `Note` objects (never exposes raw SQL)

## Getting Started

### Prerequisites

- Flutter 3.10.7 or later
- Dart 3.10.7 or later
- SQLite (bundled with Flutter)

### Installation

1. **Clone and navigate:**
   ```bash
   cd local_notes_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Platform Notes

- **Android/iOS**: Works out-of-the-box.
- **macOS/Windows/Linux**: Requires FFI initialization (already in `main.dart`).

## Usage

1. **Create a note**: Tap the floating action button ("+").
2. **Edit a note**: Tap any note in the list to open the editor.
3. **Delete a note**: Long-press any note and confirm.
4. **Data persistence**: Notes are saved to SQLite and persist across app restarts.

## Project Structure

```
lib/
  ├── main.dart                    # App entry; provider setup
  ├── models/
  │   └── note.dart               # Note data class
  ├── data/
  │   └── notes_repository.dart    # SQLite wrapper
  ├── controllers/
  │   └── notes_controller.dart    # State manager
  └── ui/
      ├── notes_list_page.dart     # Main list screen
      └── edit_note_page.dart      # Create/edit screen
```

## Key Learning Outcomes

This project teaches:

- **Async/Future patterns** in Dart: `await`, `Future<T>`, error handling.
- **Repository pattern**: Decoupling UI from data sources.
- **State management with Provider**: `watch()` for reactive UI, `read()` for one-off actions.
- **Navigation**: Using `Navigator.push()` to move between screens.
- **Separation of concerns**: DB code ≠ UI code ≠ state management.
- **Local persistence**: SQLite basics with sqflite.

## What NOT to Do (Intentionally)

- ❌ No BLoC, Riverpod, or heavy frameworks (stick with `ChangeNotifier`).
- ❌ No backend integration (offline-only).
- ❌ No animations or fancy UI (focus on logic).
- ❌ No unit/widget tests (optional next step).
- ❌ No copy-paste boilerplate from tutorials.

## Dependencies

- **flutter**: Core framework
- **provider**: ^6.1.5+1 — State management
- **sqflite**: ^2.4.0+1 — SQLite database
- **sqflite_common_ffi**: ^2.4.0+2 — FFI support for desktop
- **path**: ^1.9.1 — Cross-platform path utilities

## Next Steps (Optional Enhancements)

1. Add timestamps to the list (format with `intl` package).
2. Implement search/filter in-memory.
3. Add unit tests for the repository and controller.
4. Implement undo/redo via event sourcing.
5. Add tags or categories to notes.

## Troubleshooting

### "databaseFactory not initialized"
Ensure `main.dart` initializes the FFI factory on desktop platforms (already done).

### Notes not persisting
Verify that `NotesRepository.init()` is called before any CRUD operations. Check `main.dart` → `NotesRoot.initState()`.

### Hot reload breaks the database
Full restart (`flutter run`) is recommended after schema changes. Hot reload works for UI-only changes.

## License

Open source. Use freely for learning.

---

**Built for**: Learning Flutter architecture and async patterns.  
**Estimated time**: 1–2 days to complete and understand.  
**Target audience**: Intermediate Dart developers new to Flutter or those refining architecture skills.
