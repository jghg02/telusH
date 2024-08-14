//
//  MovieServiceTest.swift
//  TelusHAssessmentTests
//
//  Created by Josue Hernandez on 2024-08-14.
//

import XCTest
import NET
@testable import TelusHAssessment

final class MovieServiceTest: XCTestCase {

    var movieService: MovieService!
    var mockClient: MockNETRequest!

    func testFetchPopularMovies_Success() async throws {
        let request = MockNETRequest()
        let client = NETClient<MoviesResponse, RegistrationError>(requestLoader: request)
        
        let expectedURL = URLRequest.testWithExtraProperties
        _ = await client.request(expectedURL)
        
        XCTAssertEqual(request.lastLoadedRequest, expectedURL)
    }


}

class MockNETRequest: NETRequestLoader {
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: URLError?

    private(set) var lastLoadedRequest: URLRequest?

    func request(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, URLError?) -> Void) {
        lastLoadedRequest = request
        completion(nextData, nextResponse, nextError)
    }

    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        lastLoadedRequest = request
        if let error = nextError {
            throw error
        }
        return (nextData ?? Data(), nextResponse ?? HTTPURLResponse())
    }

}

// MARK: - Helper JSONDecoder
extension JSONEncoder {
    static var convertingKeysFromSnakeCase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

extension URL {
    static var test = Self(string: "https://jghg02.com")!
}

extension URLRequest {
    static var test = Self(url: URL.test)
    static var testWithExtraProperties = Self(
        url: URL.test,
        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
        timeoutInterval: 42.0
    )
}
