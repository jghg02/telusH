//
//  MainViewModel.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import Foundation
import Combine

class MainViewModel {
    private let fetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init(fetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol = FetchPopularMoviesUseCase()) {
        self.fetchPopularMoviesUseCase = fetchPopularMoviesUseCase
    }
    
    func loadMovies() {
        isLoading = true
        Task {
            let result = await fetchPopularMoviesUseCase.execute()
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                switch result {
                case .success(let movies):
                    self.movies = movies.results
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
