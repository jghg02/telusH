//
//  MovieRepositoryTest.swift
//  TelusHAssessmentTests
//
//  Created by Josue Hernandez on 2024-08-13.
//

import XCTest
@testable import TelusHAssessment

final class MovieRepositoryTests: XCTestCase {
    
    var mockService: MockMovieService!
    var repository: MovieRepository!

    override func setUp() {
        super.setUp()
        mockService = MockMovieService()
        repository = MovieRepository(movieService: mockService)
    }

    override func tearDown() {
        mockService = nil
        repository = nil
        super.tearDown()
    }

    func testGetPopularMoviesReturnsSuccess() async {
        // Given
        let expectedMovies = MoviesResponse(
            page: 1,
            results: [
                Movie(
                    id: 1,
                    title: "Test Movie",
                    overview: "Test Overview",
                    posterPath: nil,
                    releaseDate: "2024-08-12",
                    voteAverage: 7.5,
                    voteCount: 100,
                    adult: false,
                    backdropPath: nil,
                    genreIds: [28, 12],
                    originalLanguage: "en",
                    originalTitle: "Test Movie",
                    video: false,
                    popularity: 100.0
                )
            ],
            totalPages: 1,
            totalResults: 1
        )
        
        mockService.popularMoviesResult = .success(expectedMovies)
        
        // When
        let result = await repository.getPopularMovies()

        // Then
        switch result {
        case .success(let moviesResponse):
            XCTAssertNotNil(moviesResponse)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testGetPopularMoviesReturnsFailure() async {
        // Given
        let expectedError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch movies"])
        mockService.popularMoviesResult = .failure(expectedError)
        
        // When
        let result = await repository.getPopularMovies()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error as NSError):
            XCTAssertEqual(error, expectedError, "Expected the error to be returned by getPopularMovies()")
        default:
            XCTFail("Expected NSError, but got a different error")
        }
    }
    
    func testGetSimilarMoviesReturnsSuccess() async {
        // Given
        let expectedMovies = MoviesResponse(
            page: 1,
            results: [
                Movie(
                    id: 2,
                    title: "Similar Movie",
                    overview: "Similar Overview",
                    posterPath: nil,
                    releaseDate: "2024-08-12",
                    voteAverage: 8.0,
                    voteCount: 200,
                    adult: false,
                    backdropPath: nil,
                    genreIds: [16, 35],
                    originalLanguage: "en",
                    originalTitle: "Similar Movie",
                    video: false,
                    popularity: 150.0
                )
            ],
            totalPages: 1,
            totalResults: 1
        )
        
        mockService.similarMoviesResult = .success(expectedMovies)
        
        // When
        let result = await repository.getSimilarMovies(movieId: 2)

        // Then
        switch result {
        case .success(let moviesResponse):
            XCTAssertNotNil(moviesResponse)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testGetSimilarMoviesReturnsFailure() async {
        // Given
        let expectedError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch similar movies"])
        mockService.similarMoviesResult = .failure(expectedError)
        
        // When
        let result = await repository.getSimilarMovies(movieId: 2)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error as NSError):
            XCTAssertEqual(error, expectedError, "Expected the error to be returned by getSimilarMovies()")
        default:
            XCTFail("Expected NSError, but got a different error")
        }
    }
}

class MockMovieService: MovieServiceProtocol {
    var popularMoviesResult: Result<MoviesResponse, Error>!
    var similarMoviesResult: Result<MoviesResponse, Error>!
    
    func fetchPopularMovies() async -> Result<MoviesResponse, Error> {
        return popularMoviesResult
    }
    
    func fetchSimilarMovies(movieId: Int) async -> Result<MoviesResponse, Error> {
        return similarMoviesResult
    }
}
