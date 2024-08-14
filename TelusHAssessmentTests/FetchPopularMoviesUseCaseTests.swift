//
//  FetchPopularMoviesUseCaseTests.swift
//  TelusHAssessmentTests
//
//  Created by Josue Hernandez on 2024-08-13.
//

import XCTest
@testable import TelusHAssessment

final class FetchPopularMoviesUseCaseTests: XCTestCase {
    
    var mockRepository: MockMovieRepository!
    var useCase: FetchPopularMoviesUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        useCase = FetchPopularMoviesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func testExecuteReturnsSuccess() async {
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
        
        mockRepository.result = .success(expectedMovies)
        
        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .success(let moviesResponse):
            XCTAssertNotNil(moviesResponse)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testExecuteReturnsFailure() async {
        // Given
        let expectedError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch movies"])
        mockRepository.result = .failure(expectedError)
        
        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error as NSError):
            XCTAssertEqual(error, expectedError, "Expected the error to be returned by execute()")
        default:
            XCTFail("Expected NSError, but got a different error")
        }
    }
}

// Mock
class MockMovieRepository: MovieRepositoryProtocol {
    var result: Result<MoviesResponse, Error>!

    func getPopularMovies() async -> Result<MoviesResponse, Error> {
        return result
    }
    func getSimilarMovies(movieId: Int) async -> Result<TelusHAssessment.MoviesResponse, any Error> {
        return result
    }
}
