//
//  MainCoordinatorTests.swift
//  TelusHAssessmentTests
//
//  Created by Josue Hernandez on 2024-08-13.
//

import XCTest
import UIKit
@testable import TelusHAssessment

final class MainCoordinatorTests: XCTestCase {
    
    var mockNavigationController: MockNavigationController!
    var coordinator: MainCoordinator!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        coordinator = MainCoordinator(navigationController: mockNavigationController)
    }

    override func tearDown() {
        mockNavigationController = nil
        coordinator = nil
        super.tearDown()
    }

    func testStartPushesMainViewController() {
        // When
        coordinator.start()

        // Then
        XCTAssertTrue(mockNavigationController.pushedViewController is MainViewController, "Expected MainViewController to be pushed")
    }
    
    func testShowMovieDetailPushesMovieDetailViewController() {
        // Given
        let movie = Movie(
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

        // When
        coordinator.showMovieDetail(movie: movie)

        // Then
        XCTAssertTrue(mockNavigationController.pushedViewController is MovieDetailViewController, "Expected MovieDetailViewController to be pushed")

        let pushedViewController = mockNavigationController.pushedViewController as? MovieDetailViewController
        XCTAssertEqual(pushedViewController?.movie.title, movie.title, "Expected movie title to match the pushed MovieDetailViewController's movie title")
    }
}

class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
