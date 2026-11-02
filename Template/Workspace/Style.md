# Universal Swift & SwiftUI Style Guide

> [!IMPORTANT]
> This document defines the **strict, authoritative coding standards, architecture patterns, file hierarchies, and UI/UX conventions** for Swift and SwiftUI projects. It serves as an exhaustive reference for project structure, formatting, native API selection, implicit Swift conventions, and documentation standards.

---

## Table of Contents

1. [Golden Rules & Zero-Tolerance Policies](#1-golden-rules--zero-tolerance-policies)
2. [Comment & Documentation Standards](#2-comment--documentation-standards)
   - [Strict Ban on Trivial & Inline Section Comments](#strict-ban-on-trivial--inline-section-comments)
   - [DocC Documentation (`///`)](#docc-documentation-)
3. [Whitespace & MARK Formatting (The 2-1 Rule)](#3-whitespace--mark-formatting-the-2-1-rule)
4. [Universal Project & Folder Hierarchy](#4-universal-project--folder-hierarchy)
   - [Standard Tree Layout](#standard-tree-layout)
   - [Architectural Separation of Concerns](#architectural-separation-of-concerns)
5. [SwiftUI View Architecture](#5-swiftui-view-architecture)
   - [View Struct Layout](#view-struct-layout)
   - [Components Extension (`// MARK: - COMPONENTS`)](#components-extension----mark---components)
   - [Methods Extension (`// MARK: - METHODS`)](#methods-extension----mark---methods)
   - [Preview Section (`// MARK: - PREVIEW`)](#preview-section----mark---preview)
   - [Canonical View Implementation Example](#canonical-view-implementation-example)
6. [Service & Manager Pattern](#6-service--manager-pattern)
   - [The 3-Tier Lifecycle](#the-3-tier-lifecycle)
   - [Protocol Definition (`<Domain>Service.swift`)](#protocol-definition-domainserviceswift)
   - [Concrete Implementations (`<API><Domain>Service.swift`)](#concrete-implementations-apidomainserviceswift)
   - [Mock Implementation (`Mock<Domain>Service.swift`)](#mock-implementation-mockdomainserviceswift)
   - [Manager Class (`<Domain>Manager.swift`)](#manager-class-domainmanagerswift)
   - [Canonical Manager & Service Implementation Example](#canonical-manager--service-implementation-example)
7. [Implicit Swift & Native-First SwiftUI Guidelines](#7-implicit-swift--native-first-swiftui-guidelines)
   - [Always Prefer Inferred & Implicit Swift Features (NO Boilerplate Inits)](#always-prefer-inferred--implicit-swift-features-no-boilerplate-inits)
   - [Always Prefer Native Framework Components](#always-prefer-native-framework-components)
   - [Shorthand Initializers](#shorthand-initializers)
   - [Modifier Chaining vs. Custom Wrappers](#modifier-chaining-vs-custom-wrappers)
   - [Apple Documentation & Xcode MCP Integration](#apple-documentation--xcode-mcp-integration)
8. [Apple Design & Fluid Interface Foundations](#8-apple-design--fluid-interface-foundations)
   - [Response & Immediate Feedback](#response--immediate-feedback)
   - [Physics-Based Motion & Springs](#physics-based-motion--springs)
   - [Direct Manipulation & Velocity Handoff](#direct-manipulation--velocity-handoff)
   - [Materials, Translucency & Depth](#materials-translucency--depth)
   - [Multimodal Sensory Feedback](#multimodal-sensory-feedback)
   - [Typography & Hierarchy](#typography--hierarchy)
9. [External Packages & Dependencies](#9-external-packages--dependencies)
10. [Pre-Commit Quality Checklist](#10-pre-commit-quality-checklist)

---

## 1. Golden Rules & Zero-Tolerance Policies

1. **NO Boilerplate Initializers — Always Prefer Implicit & Synthesized Behavior**:
   - Swift automatically synthesizes memberwise initializers for structs and property initializers with defaults.
   - **NEVER** write manual boilerplate initializers like:
     ```swift
     // ❌ STRICTLY FORBIDDEN
     init(title: String) {
         self.title = title
     }
     ```
   - Custom initializers are **only** permitted when there is non-inferred, non-synthesizable custom logic (such as converting parameters, binding transformations, or custom class initializers). If Swift can synthesize or infer it, **always use the implicit synthesized version**.
2. **NO Useless or Placeholder Comments**:
   - **NEVER** write inline placeholder comments such as `// @State`, `// @Environment`, `// @Binding`, `// variables / computed values`, `// Non inferred / custom inits ONLY`, `// functions or computed vars that return a view`, or `// helper functions that chain methods...`.
   - The only comments permitted in source files are **canonical `// MARK: - <SECTION>` markers** and **DocC documentation (`///`)**.
3. **NO Trivial Wrapper Methods**:
   - The `// MARK: - METHODS` section is strictly reserved for non-trivial view orchestration, complex animations, coordinate calculations, or multi-step logic.
   - **NEVER** write one-line forwarding methods (e.g. `func dismissView() { dismiss() }` or `func play() { manager.play() }`). Invoke system actions or manager APIs directly at the call site.
4. **Native-First Implementation**:
   - Always leverage built-in SwiftUI components and standard system modifiers before rolling custom layout hacks (e.g. use `LabeledContent` instead of `HStack { Text(...); Spacer(); Text(...) }`).
5. **Exact MARK Whitespace (The 2-1 Rule)**:
   - Every `// MARK: - <SECTION>` line must be preceded by **exactly 2 blank lines** and followed by **exactly 1 blank line**.
6. **Single-Line Compact Statements**:
   - Format short single-statement conditionals, guards, and defers inline on a single line:
     - `if condition { execute() }`
     - `guard let user = currentUser else { return }`
     - `defer { isLoading = false }`
---

## 2. Comment & Documentation Standards

### Strict Ban on Trivial & Inline Section Comments
Swift syntax is self-describing; annotations like `@State`, `@Environment`, and `@Binding` already convey property semantics. Writing comments that repeat the declaration is banned. Redundant boilerplate initializers are equally banned.

#### ❌ Incorrect (Banned):
```swift
// MARK: - VIEW

struct CustomView: View {

    // @Environment
    @Environment(AppManager.self) private var appManager

    // @Binding
    // (None)

    // @State
    @State private var isExpanded: Bool = false

    // variables / computed values
    let title: String

    // Non inferred / custom inits ONLY
    init(title: String) {
        self.title = title
    }
```

#### ✅ Correct:
```swift
// MARK: - VIEW

struct CustomView: View {

    @Environment(AppManager.self) private var appManager
    @State private var isExpanded: Bool = false

    let title: String
```

### DocC Documentation (`///`)
Use triple-slash DocC comments for types, protocols, public interfaces, non-obvious algorithms, and configuration parameters. Write clear, concise documentation that renders seamlessly in Xcode's Quick Help inspector (`Option + Click`).

```swift
/// Manages user authentication credentials, session restoration, and token persistence.
@Observable
final class AuthManager {

    /// The currently authenticated user profile, or `nil` if unauthenticated.
    private(set) var currentUser: User?

    /// Authenticates using a remote verification code.
    ///
    /// - Parameter pinCode: The 4-character authorization PIN.
    /// - Throws: `AuthError.invalidPin` if the code expired or was rejected.
    func authenticate(pinCode: String) async throws {
        // Implementation
    }
}
```

---

## 3. Whitespace & MARK Formatting (The 2-1 Rule)

To maintain consistent visual structure across all codebase files, MARK comment spacing is strictly defined:

```
[Preceding Code Block]
<Blank Line 1>
<Blank Line 2>
// MARK: - SECTION_NAME
<Blank Line 1>
[Following Code Block]
```

- **Exactly 2 blank lines** before every `// MARK: - <SECTION>`.
- **Exactly 1 blank line** after every `// MARK: - <SECTION>`.

### Canonical MARK Titles:
- `// MARK: - VIEW`
- `// MARK: - COMPONENTS`
- `// MARK: - METHODS`
- `// MARK: - PREVIEW`
- `// MARK: - INITIALIZER` (used in classes/managers)
- `// MARK: - PUBLIC API`
- `// MARK: - PRIVATE HELPERS`

---

## 4. Universal Project & Folder Hierarchy

The codebase organizes code strictly by architecture layer and domain responsibility:

### Standard Tree Layout

```
<ProjectRoot>
├── main.swift / <AppName>App.swift  # Application entry point
├── Assets.xcassets                  # Asset catalogs, colors, icons
│
├── Service/
│   ├── Models/
│   │   ├── Core/                    # Cross-cutting models (AppState, SessionInfo, AppTheme)
│   │   ├── Enums/                   # Universal enumerations (AppTab, ViewLayoutMode, Status)
│   │   └── Helpers/                 # Network clients, Keychain wrappers, Logger, Crypto
│   │
│   └── Managers/
│       └── <Domain>Manager/         # Dedicated folder per functional domain
│           ├── <Domain>Manager.swift # @Observable domain coordinator class
│           ├── <Domain>Service.swift # Abstract service protocol
│           ├── <Domain>Models/       # Domain-specific DTOs/models (only if required)
│           └── Services/             # Concrete implementations
│               ├── <API><Domain>Service.swift   # e.g., SwiftDataUserService, NetworkAuthService
│               └── Mock<Domain>Service.swift    # Deterministic mock service for tests & previews
│
└── Views/
    ├── Components/                  # Generic, universally reusable UI components (e.g. CachedImageView)
    ├── Core/
    │   ├── ContentView.swift        # Root tab/split coordinator & modal hosts
    │   └── <DomainTab>/             # Main sections, tabs, or user workflows (e.g., Home, Auth, Settings)
    │       ├── Components/          # Components used strictly within this domain
    │       ├── <DomainTab>View.swift # Primary screen for the domain
    │       └── <DomainTabSubview>View.swift # Subviews primarily owned by this domain (e.g., DetailView)
    │
    └── Extensions/
        └── <Domain>+EXT.swift       # e.g., View+EXT.swift, Color+EXT.swift, Date+EXT.swift
```

### Architectural Separation of Concerns

1. **`Service/Models/`**:
   - Pure data structures, DTOs, domain models, and enums.
   - Independent of UI frameworks.
2. **`Service/Managers/<Domain>Manager/`**:
   - Encapsulates business logic, state mutation, and backend communication for a single domain.
   - Exposes clean `@Observable` state and `async` action methods to the views.
   - Contains its own protocol and concrete service variants (`Services/`).
3. **`Views/Components/`**:
   - Reusable across any view or domain in the application (e.g., remote image loaders, badges, glass containers).
4. **`Views/Core/<DomainTab>/`**:
   - Feature-specific UI. Domain-specific sub-components belong in `Views/Core/<DomainTab>/Components/`.
   - Views that conceptually belong to a domain live in that domain's directory, even if navigated to from elsewhere (e.g., `ItemDetailView` belongs in the media or catalog domain).
5. **`Views/Extensions/`**:
   - Ergonomic extensions on SwiftUI and Foundation types.

---

## 5. SwiftUI View Architecture

All SwiftUI views adhere to a modular structure separated into the view declaration, view components, complex methods, and preview.

### View Struct Layout
Declared directly under `// MARK: - VIEW` in the following sequence:
1. `@Environment` properties
2. `@Binding` properties
3. `@State` properties
4. Stored constants, dependencies, computed properties, and `@Namespace`
5. Non-inferred custom initializers **ONLY** when non-synthesizable initialization logic is strictly required (never write boilerplate memberwise initializers)
6. `var body: some View`

### Components Extension (`// MARK: - COMPONENTS`)
- Declared as `extension <ViewName>`.
- Houses subviews marked `@ViewBuilder` (either computed properties or functions).
- Keeps `var body` high-level, declarative, and easily readable.

### Methods Extension (`// MARK: - METHODS`)
- Declared as `extension <ViewName>`.
- Houses complex logic, gesture processing, and animation orchestration.
- **Omit this entire section if the view does not contain complex logic.**

### Preview Section (`// MARK: - PREVIEW`)
- Modern `#Preview` block.
- Injects necessary mock managers and environment objects to ensure immediate, crash-free preview rendering.

### Canonical View Implementation Example

```swift
//
//  ProfileOverviewView.swift
//  UniversalApp
//

import SwiftUI


// MARK: - VIEW

struct ProfileOverviewView: View {

    @Environment(UserManager.self) private var userManager
    @Environment(\.dismiss) private var dismiss

    @State private var isEditingBio: Bool = false
    @State private var bioDraft: String = ""

    let user: User

    var body: some View {
        NavigationStack {
            List {
                profileHeaderSection
                accountDetailsSection
                preferencesSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


// MARK: - COMPONENTS

extension ProfileOverviewView {

    @ViewBuilder
    private var profileHeaderSection: some View {
        Section {
            HStack(spacing: 16) {
                CachedAsyncImageView(imageURL: user.avatarURL)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .font(.headline)

                    Text(user.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }

    @ViewBuilder
    private var accountDetailsSection: some View {
        Section("Account") {
            LabeledContent("Member Since", value: user.formattedJoinDate)
            LabeledContent("Role", value: user.roleTitle)
            LabeledContent("Status") {
                Text(user.isActive ? "Active" : "Suspended")
                    .foregroundStyle(user.isActive ? .green : .red)
            }
        }
    }

    @ViewBuilder
    private var preferencesSection: some View {
        Section("Bio") {
            if isEditingBio {
                TextField("About you", text: $bioDraft, axis: .vertical)
                    .lineLimit(3...6)

                Button("Save Bio", systemImage: "checkmark") {
                    saveBio()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text(user.bio.isEmpty ? "No bio provided" : user.bio)
                    .foregroundStyle(user.bio.isEmpty ? .secondary : .primary)

                Button("Edit Bio", systemImage: "pencil") {
                    bioDraft = user.bio
                    isEditingBio = true
                }
                .buttonStyle(.bordered)
            }
        }
    }
}


// MARK: - METHODS

extension ProfileOverviewView {

    private func saveBio() {
        Task {
            await userManager.updateBio(bioDraft)
            withAnimation(.easeInOut(duration: 0.2)) {
                isEditingBio = false
            }
        }
    }
}


// MARK: - PREVIEW

#Preview {
    ProfileOverviewView(user: .mockUser)
        .environment(UserManager(service: MockUserService()))
}
```

---

## 6. Service & Manager Pattern

The business tier uses a decoupled **Protocol-Service-Manager** pattern:

```
┌──────────────────────────────────────────────┐
│                 SwiftUI View                 │
│         @Environment(DomainManager.self)     │
└──────────────────────┬───────────────────────┘
                       │ Action calls & observation
                       ▼
┌──────────────────────────────────────────────┐
│       <Domain>Manager (@Observable class)    │
│           State, mutation & validation       │
└──────────────────────┬───────────────────────┘
                       │ Protocol interface
                       ▼
┌──────────────────────────────────────────────┐
│          <Domain>Service (Protocol)          │
├──────────────────────┬───────────────────────┤
│                      │                       │
▼                      ▼                       ▼
<API><Domain>Service   Mock<Domain>Service     Local<Domain>Service
(Remote / SwiftData)   (Previews & Unit Tests) (Offline Cache)
```

### Protocol Definition (`<Domain>Service.swift`)
```swift
//
//  UserService.swift
//  UniversalApp
//

import Foundation

/// Defines operations for fetching and persisting user data.
protocol UserService: Sendable {

    func fetchUserProfile(id: String) async throws -> User
    func updateUserBio(id: String, bio: String) async throws
}
```

### Concrete Implementations (`<API><Domain>Service.swift`)
```swift
//
//  NetworkUserService.swift
//  UniversalApp
//

import Foundation

/// Production user service communicating via REST/GraphQL API.
struct NetworkUserService: UserService {

    var networkClient: NetworkClient = .shared

    func fetchUserProfile(id: String) async throws -> User {
        try await networkClient.request(endpoint: "/users/\(id)")
    }

    func updateUserBio(id: String, bio: String) async throws {
        try await networkClient.request(endpoint: "/users/\(id)/bio", body: ["bio": bio])
    }
}
```

### Mock Implementation (`Mock<Domain>Service.swift`)
```swift
//
//  MockUserService.swift
//  UniversalApp
//

import Foundation

/// In-memory mock service for previews and automated test suites.
struct MockUserService: UserService {

    var stubbedUser: User = .mockUser

    func fetchUserProfile(id: String) async throws -> User {
        stubbedUser
    }

    func updateUserBio(id: String, bio: String) async throws {
        // Deterministic mock success
    }
}
```

### Manager Class (`<Domain>Manager.swift`)
```swift
//
//  UserManager.swift
//  UniversalApp
//

import Foundation
import Observation

/// Orchestrates user profile state and sync operations.
@Observable
final class UserManager {

    // MARK: - PROPERTIES

    private(set) var currentUser: User?
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    let service: UserService


    // MARK: - INITIALIZER

    init(service: UserService = NetworkUserService()) {
        self.service = service
    }


    // MARK: - PUBLIC API

    func loadUser(id: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            currentUser = try await service.fetchUserProfile(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateBio(_ newBio: String) async {
        guard let current = currentUser else { return }
        do {
            try await service.updateUserBio(id: current.id, bio: newBio)
            currentUser?.bio = newBio
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

---

## 7. Implicit Swift & Native-First SwiftUI Guidelines

Adherence to Apple Human Interface Guidelines (HIG), utilizing modern idiomatic SwiftUI APIs, and embracing Swift's implicit/synthesized capabilities is mandatory.

### Always Prefer Inferred & Implicit Swift Features (NO Boilerplate Inits)
Swift is designed to be expressive and concise. Always rely on compiler inference and synthesis:

1. **Synthesized Memberwise Initializers**:
   - Structs automatically get memberwise initializers generated by the compiler.
   - **Writing manual initializers that merely assign parameters to stored properties is strictly banned.**
   ```swift
   // ❌ BANNED: Manual boilerplate
   struct MediaCard: View {
       let item: MediaItem
       let showBadge: Bool

       init(item: MediaItem, showBadge: Bool) {
           self.item = item
           self.showBadge = showBadge
       }
   }

   // ✅ CORRECT: Inferred synthesized memberwise initializer
   struct MediaCard: View {
       let item: MediaItem
       let showBadge: Bool
   }
   ```
2. **Default Property Values**:
   - Assign defaults directly at the declaration site (`var isConnected: Bool = true`) rather than in an explicit initializer.
3. **Implicit Returns**:
   - Omit the `return` keyword in single-expression closures, functions, and computed properties.
4. **Type Inference & Dot Syntax**:
   - Leverage Swift's type inference and leading dot syntax (`.automatic`, `.regular`, `.shared`) rather than repeating explicit types.

### Always Prefer Native Framework Components
Avoid building custom layout workarounds for elements already solved by native SwiftUI components:

| Instead of Custom Layout Hacks | Use Native Component |
| :--- | :--- |
| `HStack { Text("Title"); Spacer(); Text("Value") }` | `LabeledContent("Title", value: "Value")` |
| `ZStack { ProgressView(); Text("Loading...") }` | `ContentUnavailableView("Loading...", systemImage: "...")` |
| Custom empty states | `ContentUnavailableView` or `ContentUnavailableView.search(text:)` |
| Custom card outlines and rounded rect clips | System shapes with `.glassEffect(...)`, `.background(.ultraThinMaterial)`, or `.containerBackground(...)` |
| Custom segmented selectors | `Picker(..., selection: ...) { ... }.pickerStyle(.segmented)` |
| Custom badge containers | `.badge(...)` |

### Shorthand Initializers
Prefer compact, direct initializers over verbose nested containers:

#### ❌ Verbose (Avoid):
```swift
Button {
    performAction()
} label: {
    Label("Save Item", systemImage: "square.and.arrow.down")
}
```

#### ✅ Shorthand (Preferred):
```swift
Button("Save Item", systemImage: "square.and.arrow.down") {
    performAction()
}
```

```swift
// NavigationLink shorthand
NavigationLink("Settings", systemImage: "gear", destination: SettingsView())

// Toggle shorthand
Toggle("Notifications", isOn: $isNotificationsEnabled)

// ShareLink shorthand
ShareLink("Share", item: shareURL)
```

### Modifier Chaining vs. Custom Wrappers
Configure elements using standard SwiftUI modifier chains rather than embedding views inside custom frames and containers:

#### ❌ Custom Wrapper (Avoid):
```swift
Button {
    deleteItem()
} label: {
    Text("Delete")
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.red)
        .cornerRadius(8)
}
```

#### ✅ Idiomatic Modifier Chaining (Preferred):
```swift
Button("Delete", role: .destructive) {
    deleteItem()
}
.buttonStyle(.borderedProminent)
.buttonBorderShape(.capsule)
.controlSize(.regular)
```

### Apple Documentation & Xcode MCP Integration
- **Consult Documentation**: Regularly reference Apple Developer Documentation to discover first-party view modifiers and system components introduced in recent SDKs.
- **Xcode MCP Integration**: When available, use `DocumentationSearch` locally to query documentation for the latest system APIs, deprecations, and design patterns.

---

## 8. Apple Design & Fluid Interface Foundations

Interfaces feel like an extension of the user when motion starts from the current on-screen value, inherits user velocity, resists at boundaries, and can be redirected mid-flight. Always design with these Apple principles in mind:

### Response & Immediate Feedback
- **Feedback on Touch-Down**: Provide immediate visual and sensory feedback on touch-down (press), not on release (touch-up). Waiting for release causes perceptible lag.
- **Continuous 1:1 Tracking**: During gestures (drags, sheets, sliders), track the finger 1:1 continuously across the interaction.
- **Audit Latency**: Eliminate arbitrary delays, unnecessary debounces, or blocking transitions on the input path.

### Physics-Based Motion & Springs
- **Springs over Scripted Durations**: Use interruptible springs for interactive elements rather than linear or fixed-duration ease curves.
- **Apple Spring Parameters**:
  - **Default UI Spring**: Critically damped (`response: 0.35`, `dampingRatio: 1.0`) — graceful, settles cleanly with zero overshoot.
  - **Momentum / Interactive Spring**: Under-damped (`response: 0.35`, `dampingRatio: 0.8`) — slight bounce only when momentum or a flick preceded it.
  - **Drawer / Sheet Spring**: (`response: 0.3`, `dampingRatio: 0.8`).
- **Interruptibility**: Never lock out input during transitions. Animations must smoothly retarget from live presentation values without jarring velocity cuts.

### Direct Manipulation & Velocity Handoff
- **Preserve Grab Offset**: Maintain the touch offset from where the user grabbed the element.
- **Project Momentum**: Animate toward where the gesture is headed based on release velocity, rather than simply snapping to the nearest threshold from the release point.
- **Rubber-Banding**: Apply progressive resistance at boundaries rather than hard stops.

### Materials, Translucency & Depth
- **Translucent Chrome**: Use `.background(.ultraThinMaterial)` or system glass for toolbars, navigation headers, and floating surfaces with content scrolling underneath.
- **Hierarchy via Weight**: Darker/heavier materials designate structural background chrome; lighter surfaces draw focus to interactive elements. Never stack light translucent layers on top of each other.
- **Vibrancy & Contrast**: Ensure readable contrast over translucent materials using semantic secondary and tertiary styles with system dynamic type.

### Multimodal Sensory Feedback
- **Causality & Harmony**: Fire visual state changes, sound, and `.sensoryFeedback` on the exact same frame.
- **Restraint**: Reserve haptic feedback for meaningful milestones (commit, snap, selection change, error). Overuse degrades user sensitivity.

### Typography & Hierarchy
- **System Fonts First**: Default to system fonts (`SF Pro`) with automatic optical sizing.
- **Dynamic Type**: Always support Dynamic Type so layouts expand gracefully without clipping.
- **Hierarchical Tracking**: Headings benefit from slightly tighter tracking; small captions require slightly looser tracking for legibility.

---

## 9. External Packages & Dependencies

External packages are allowed across the project. However, to maintain code quality, maintainability, and alignment with Apple's platform conventions:

1. **Images & Remote Caching**:
   - `SDWebImage` / `SDWebImageSwiftUI` is the standard library for remote image downloading, memory/disk caching, and progressive image pipelines.
2. **Navigation & Dynamic Routing**:
   - `SwiftfulRouting` is the standard library when dynamic or decoupled stack/sheet/fullscreen routing is required beyond native SwiftUI navigation.
3. **Platform First**:
   - When Apple provides a first-party framework for a capability (e.g., `AVKit`, `SwiftData`, `Observation`, `CryptoKit`, `StoreKit`), favor the system framework over third-party alternatives.

---

## 10. Pre-Commit Quality Checklist

Before submitting code, verify each item on this checklist:

- [ ] **NO Boilerplate Inits**: Verified that structs use implicit synthesized memberwise initializers. No manual `init(...) { self.... = ... }`.
- [ ] **No Inline Section Comments**: Removed all `// @State`, `// @Environment`, `// @Binding`, `// variables / computed values`, and placeholder comments.
- [ ] **Exact 2-1 Whitespace**: Verified **exactly 2 blank lines** before every `// MARK: - <SECTION>` and **exactly 1 blank line** after.
- [ ] **No Wrapper Methods**: Verified that methods in `// MARK: - METHODS` contain meaningful logic and are not trivial wrappers for managers or system actions.
- [ ] **Correct Directory Placement**:
  - General components in `Views/Components/`.
  - Feature screens in `Views/Core/<DomainTab>/`.
  - Feature-specific subcomponents in `Views/Core/<DomainTab>/Components/`.
  - Business logic, protocols, and services under `Service/Managers/<Domain>Manager/`.
- [ ] **Native-First SwiftUI**: Used `LabeledContent`, shorthand initializers (`Button(title, systemImage: action)`), and standard modifier chains (`.buttonStyle`, `.buttonBorderShape`).
- [ ] **Apple Design & Motion**: Used interruptible springs (`dampingRatio: 1.0` or `0.8`), instant press feedback, translucent materials, and harmonious haptics.
- [ ] **DocC Documentation**: Public APIs, protocols, and manager properties are documented with triple-slash (`///`) DocC comments.
- [ ] **Clean Build**: Verified that the target builds cleanly with zero errors.
