//
//  MainViewModelTest.swift
//  TelusHAssessmentTests
//
//  Created by Josue Hernandez on 2024-08-13.
//

import XCTest
import Combine
@testable import TelusHAssessment

final class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockUseCase: MockFetchPopularMoviesUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchPopularMoviesUseCase()
        viewModel = MainViewModel(fetchPopularMoviesUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadMoviesSuccess() {
        // Given
        let expectedMovies = [
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
                ]
        let moviesResponse = MoviesResponse(page: 1, results: expectedMovies, totalPages: 1, totalResults: 1)
        mockUseCase.result = .success(moviesResponse)
        
        let expectation = XCTestExpectation(description: "Loading movies succeeds and updates movies")
        
        // When
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertNotNil(movies)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadMovies()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadMoviesFailure() {
        // Given
        let expectedError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        mockUseCase.result = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Loading movies fails and updates errorMessage")
        
        // When
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Test Error")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadMovies()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    func testLoadingState() {
        // Given
        mockUseCase.result = .success(MoviesResponse(page: 1, results: [], totalPages: 1, totalResults: 0))
        
        let expectation = XCTestExpectation(description: "Loading state is set correctly")
        
        // When
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertTrue(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadMovies()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
}

class MockFetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol {
    var result: Result<MoviesResponse, Error>!
    
    func execute() async -> Result<MoviesResponse, Error> {
        return result
    }
}
