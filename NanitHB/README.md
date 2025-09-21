# Nanit Happy Birthday App

### MVVM Pattern
The app implements the Model-View-ViewModel (MVVM) pattern, which provides:
- Clear separation of concerns
- Better testability
- Reactive data flow using Combine

### Navigation
Navigation is done by Router implementation.

### Protocol-Oriented Approach
The project uses protocols for screen modules:
- View models are defined through protocols (e.g., `BirthdayScreenViewModelProtocol`, `ChildInfoViewModelProtocol`)
- Repositories follow protocol definitions (e.g., `ChildInfoRepositoryProtocol`)
- This approach enhances testability and allows for easy mock implementations

Having more time on task would prefer to use more protocols for other system components.

### Dependency Injection
The app uses a custom DI container (`AppContainer`) to manage dependencies:
- Centralized dependency management
- Easy to modify implementations
- Supports testing by allowing mock injections

### Modular Structure
Each screen module contains its own:
- Models
- Views
- ViewModels
- Protocols
- UI Components

Other components are separated by top-level folders, which can be moved to modules in futures keeping the same structure.

### Could have been added having more time
- Add support for iPad: design adjustments and UI component optimizations
- Add snapshot tests for key screens to test different states and prevent regressions
- Add unit test for ViewModels.
- Add integration tests for Router, AttachmentsController, and PersistentStorage
- Some edge cases handled with logging could be handled by notifying the user about the problem and providing actionable solutions