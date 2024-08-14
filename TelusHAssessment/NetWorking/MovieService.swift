//
//  MovieService.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import Foundation
import NET

enum MovieServiceError: Error {
    case invalidURL
    case requestFailed(Error)
}

protocol MovieServiceProtocol {
    func fetchPopularMovies() async -> Result<MoviesResponse, Error>
}

class MovieService: MovieServiceProtocol {
    private let client: NETClient<MoviesResponse, RegistrationError>
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let authorizationHeader = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkM2E4ODU0ZTgxZGNiOTJjNjI3YWFjYjUwYTcwM2RiNyIsIm5iZiI6MTcyMzUxMjM5My40ODk5MjksInN1YiI6IjY2YmFiNTMzNWQ0ZWRhY2NlMzFhZWQyMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XAA4w_hucBqmsm6DYYuhlVgTC9YNM_v67DJjv4-KzS4"

    init(client: NETClient<MoviesResponse, RegistrationError> = NETClient()) {
        self.client = client
    }
    
    func fetchPopularMovies() async -> Result<MoviesResponse, Error> {
        let endpoint = "/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_people=71580"
        return await performRequest(with: endpoint)
    }
    
    // MARK: - Private Helper Methods
    
    private func performRequest(with endpoint: String) async -> Result<MoviesResponse, Error> {
        guard let url = buildURL(for: endpoint) else {
            return .failure(MovieServiceError.invalidURL)
        }
        
        let headers = buildHeaders()
        let request = NETRequest(url: url, headers: headers)
        
        let result = await client.request(request)
        
        switch result {
        case .success(let response):
            return .success(response.value)
        case .failure(let error):
            return .failure(MovieServiceError.requestFailed(error))
        }
    }
    
    private func buildURL(for endpoint: String) -> URL? {
        return URL(string: baseURL + endpoint)
    }
    
    private func buildHeaders() -> NETRequest.NETHeaders {
        return [
            "Authorization": authorizationHeader,
            "accept": "application/json"
        ]
    }
}
