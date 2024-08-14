//
//  MovieRepository.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import Foundation

protocol MovieRepositoryProtocol {
    func getPopularMovies() async -> Result<MoviesResponse, Error>
    func getSimilarMovies(movieId: Int) async -> Result<MoviesResponse, Error>
}

class MovieRepository: MovieRepositoryProtocol {
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    func getPopularMovies() async -> Result<MoviesResponse, Error> {
        return await movieService.fetchPopularMovies()
    }
    
    func getSimilarMovies(movieId: Int) async -> Result<MoviesResponse, Error> { // New method
        return await movieService.fetchSimilarMovies(movieId: movieId)
    }
}
