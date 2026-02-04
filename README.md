# PokeApi Clean Architecture

A clean and scalable Flutter application that interacts with the Pokémon API, demonstrating modern development practices and Clean Architecture principles.

## 🏗️ Architecture

This project follows **Clean Architecture** to ensure separation of concerns, testability, and scalability. It is divided into three main layers:

*   **Domain**: The inner layer. Contains the business logic (Use Cases) and entities. It is completely independent of other layers.
*   **Data**: The implementation layer. Handles data retrieval (Repositories) from remote sources (API) or local storage (Hive).
*   **Presentation**: The user interface layer. Uses **BLoC (Cubit)** for state management to handle UI logic and interactions.

### Tech Stack & Libraries
*   **flutter_bloc**: For state management (Cubit).
*   **dio**: For HTTP networking.
*   **hive**: For local data persistence.
*   **get_it**: For dependency injection.
*   **dartz**: For functional programming.

## ✨ Features

*   **List Pokémon**: Fetches and displays a list of Pokémon with **Pagination** (infinite scrolling).
*   **Detail View**: Shows comprehensive Pokemon details including stats, physical attributes, and types.
*   **Evolution Chain**: Visualizes the complete evolutionary family and allows navigation between forms.
*   **Modern UI**: Features **Hero Animations**, Skeleton Loading, and a responsive Grid Layout.
*   **Clean Architecture**: Clear separation of responsibilities.
*   **Dependency Injection**: Decoupled components for better testing and maintenance.

## 🚀 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/pokeApi_CleanCode_Basic.git
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

## 🧪 Testing

Run the tests to verify the application:

```bash
flutter test
```
