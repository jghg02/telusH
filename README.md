# TelusHAssessment

## Overview

TelusHAssessment is an iOS application that allows users to discover popular movies and view details about them. It follows the principles of Clean Architecture, ensuring a scalable and maintainable codebase. The app fetches data from The Movie Database (TMDb) API to display movie information, including similar movies, on a detail screen.

## Features

- **Movie List**: Displays a list of popular movies fetched from TMDb.
- **Movie Detail**: Shows detailed information about a selected movie, including title, poster, and synopsis.
- **Similar Movies**: Displays a list of similar movies under the movie details, allowing users to explore more movies.

## Architecture

This project follows the Clean Architecture approach:

- **Presentation Layer**: Contains `ViewControllers` and `ViewModels`. The `ViewControllers` are responsible for UI rendering and user interactions. The `ViewModels` contain the business logic for preparing data for the UI.
- **Domain Layer**: Contains use cases, which represent the core application logic.
- **Data Layer**: Contains the repository and service classes that handle data fetching from external sources like APIs.

## Getting Started

### Prerequisites

- Xcode 14 or later
- Swift 5.7 or later
- iOS 15.0 or later

Project Structure

- Networking: Handles network requests using the NET library, which simplifies making HTTP requests and handling responses.
- UseCases: Contains the use cases responsible for fetching movies and similar movies. Example: FetchPopularMoviesUseCase.
- Repository: Acts as the single source of truth for movie data, fetching it from the MovieService.
- Coordinator: Manages navigation between screens. Example: MainCoordinator.
- ViewControllers: UI components that display data and handle user interactions.
- ViewModels: Prepare data for the UI by interacting with use cases.
- Tests: Unit tests for various components, ensuring the reliability of the application.

## Key Components

### MainCoordinator

MainCoordinator handles the navigation flow in the app:

- start(): Launches the app with the list of popular movies.

### MainViewController

MainViewController displays the list of popular movies:

- Binds to MainViewModel to load and display movies.
- Handles user interactions to navigate to the detail view of a selected movie.

### MovieDetailViewController

MovieDetailViewController displays detailed information about a movie:

- Shows the movie’s title, poster, and synopsis.

### MovieService

MovieService fetches data from TMDb API:

- fetchPopularMovies(): Retrieves the list of popular movies.

## Dependencies

	- **[NET](https://github.com/jghg02/NET)**: A custom networking library used to handle HTTP requests and responses. Developed by me 
	- **Combine**: Apple’s framework for processing asynchronous events over time.
 
