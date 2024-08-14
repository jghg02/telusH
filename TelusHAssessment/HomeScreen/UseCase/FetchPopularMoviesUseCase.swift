//
//  FetchPopularMoviesUseCase.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import Foundation

protocol FetchPopularMoviesUseCaseProtocol {
    func execute() async -> Result<MoviesResponse, Error>
}

class FetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
    }
    
    func execute() async -> Result<MoviesResponse, Error> {
        return await repository.getPopularMovies()
    }
}
