# 📦 Satri App - Product Manager

A Flutter application for Android that allows users to register, list, and sort products. The project was built by rigorously applying the principles of **Clean Architecture**, **SOLID**, and **Clean Code**, with a highlight on the implementation of a **custom sorting algorithm (Quick Sort)** and a **local caching system**.

---

## 📌 Table of Contents
1. [About the Project](#-about-the-project)
2. [Technologies Used](#-technologies-used)
3. [Architecture and Folder Structure](#-architecture-and-folder-structure)
4. [Application Data Flow](#-application-data-flow)
5. [Technical Highlights](#-technical-highlights)
6. [How to Run the Project](#-how-to-run-the-project)

---

## 📖 About the Project

The goal of this application is to allow users to manage a list of products containing **Name**, **Purchase Price**, and **Selling Price**.

**Requirements met (according to the task scope):**
- [x] Product registration (Name, Purchase Price, Selling Price).
- [x] Paginated product list (Infinite scroll).
- [x] Custom sorting by: Name, Purchase Price, and Selling Price.
- [x] **Maximum use of custom algorithms:** Manual implementation of the Quick Sort algorithm, without using Dart's native `.sort()`.
- [x] **Local Caching System:** Products are cached locally to provide faster loading times and offline-first support.
- [x] Visual loading feedback (Overlay during registration).
- [x] Friendly error handling (Snackbars and Empty States).

---

## 🚀 Technologies Used

*   **Flutter** & **Dart**
*   **Flutter BLoC (Cubit)** for reactive state management.
*   **Clean Architecture** (layered separation: Data, Domain, Presentation).
*   **UUID** for generating unique identifiers.
*   **SOLID** and **Clean Code** for maintainable and testable code.

---

## 🏗️ Architecture and Folder Structure

The project is divided into three main layers, ensuring decoupling and testability:

*   **Domain:** Pure business rules (Entities, Use Cases, Contracts). Does not depend on any frameworks.
*   **Data:** Repository implementations, caching system, and data sources.
*   **Presentation:** User Interface (UI) and state management (Cubits).

### 📂 Folder Structure

```text
lib/
├── data/                          # Data Layer
│   ├── datasources/               # Data sources
│   │   ├── local/                 # Local storage (e.g., SharedPreferences/SQLite)
│   │   └── cache/                 # 🆕 Caching System Implementation
│   └── repositories/              # Repository Implementations (Handles cache logic)
│
├── domain/                        # Domain Layer (Business Rules)
│   ├── entities/                  # Entities (ProductEntity)
│   ├── repositories/              # Repository Contracts/Abstractions
│   └── usecases/                  # Use Cases
│       ├── add_product_use_case.dart
│       ├── get_products_use_case.dart
│       └── sort_products_use_case.dart  <-- 🧠 Custom Quick Sort Algorithm
│
└── presentation/                  # Presentation Layer (UI/State)
    ├── bloc/                      # State Management (Cubit and States)
    │   └── products_cubit.dart
    └── ui/                        # User Interface
        ├── add_product/           # Add Product Screen
        │   ├── pages/
        │   └── widgets/
        └── products_list/         # Product List Screen
            ├── pages/
            └── widgets/




[👤 User]
     │
     ▼ (Interacts with the screen)
[🖥️ UI - ProductsPage]
     │
     ▼ (Triggers event: loadInitialProducts)
[🧠 Cubit - ProductsCubit]
     │
     ▼ (Calls Use Case)
[⚙️ Domain - GetProductsUseCase]
     │
     ▼ (Calls Repository abstraction)
[📦 Data - ProductRepository]
     │
     ├──> 📦 Checks Cache (ProductCacheDataSource)
     │
     ├──> (Cache Hit) ──> Returns Cached List<ProductEntity>
     │
     └──> (Cache Miss) ──> 💾 Fetches from Local Data Source
                          │
                          ├──> Saves to Cache
                          │
                          └──> Returns List<ProductEntity>
     │
     ▲ (Returns EitherOf<Failure, PaginatedResponse>)
[⚙️ Domain - GetProductsUseCase]
     │
     ▲ (Returns data to Cubit)
[🧠 Cubit - ProductsCubit]
     │
     ├──> 🧠 Applies SortProductsUseCase (Custom Quick Sort Algorithm)
     │
     ▼ (Emits new state: ProductsLoaded)
[🖥️ UI - BlocBuilder]
     │
     ▼ (Rebuilds screen with sorted list)
[👤 User] (Views updated list)