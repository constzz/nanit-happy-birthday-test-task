# Nanit Happy Birthday App

## Screenshots

### iPhone 16 Pro
<p align="row">
<img src="https://github.com/constzz/nanit-happy-birthday-test-task/blob/master/NanitHB/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-09-21%20at%2022.41.44.png" height="400" alt="iPhone 16 Pro - Child Info Screen">
<img src="https://github.com/constzz/nanit-happy-birthday-test-task/blob/master/NanitHB/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-09-21%20at%2022.41.49.png" height="400" alt="iPhone 16 Pro - Birthday Screen">
<img src="https://github.com/constzz/nanit-happy-birthday-test-task/blob/master/NanitHB/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-09-21%20at%2022.42.02.png" height="400" alt="iPhone 16 Pro - Error">
</p>

### iPhone SE (3rd generation)
<p align="row">
<img src="https://github.com/constzz/nanit-happy-birthday-test-task/blob/master/NanitHB/Screenshots/Simulator%20Screenshot%20-%20iPhone%20SE%20(3rd%20generation)%20-%202025-09-21%20at%2022.44.03.png" height="400" alt="iPhone SE - Empty Child Info Screen">
<img src="https://github.com/constzz/nanit-happy-birthday-test-task/blob/master/NanitHB/Screenshots/Simulator%20Screenshot%20-%20iPhone%20SE%20(3rd%20generation)%20-%202025-09-21%20at%2022.42.31.png" height="400" alt="iPhone SE - Child Info Screen">
<img src="https://github.com/constzz/nanit-happy-birthday-test-task/blob/master/NanitHB/Screenshots/Simulator%20Screenshot%20-%20iPhone%20SE%20(3rd%20generation)%20-%202025-09-21%20at%2022.44.15.png" height="400" alt="iPhone SE - Birthday Screen">
<img src="https://github.com/constzz/nanit-happy-birthday-test-task/blob/master/NanitHB/Screenshots/Simulator%20Screenshot%20-%20iPhone%20SE%20(3rd%20generation)%20-%202025-09-21%20at%2022.42.36.png" height="400" alt="iPhone SE - Birthday Screen">
</p>

## Architecture

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
