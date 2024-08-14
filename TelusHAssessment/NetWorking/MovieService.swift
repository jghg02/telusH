//
//  MovieService.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import Foundation
import NET

protocol MovieServiceProtocol {
    func fetchPopularMovies() async -> Result<MoviesResponse, Error>
    func fetchSimilarMovies(movieId: Int) async -> Result<MoviesResponse, Error>
}

class MovieService: MovieServiceProtocol {
    private var client = NETClient<MoviesResponse, RegistrationError>()
    
    init(client: NETClient<MoviesResponse, RegistrationError> = NETClient()) {
        self.client = client
    }
    
    func fetchPopularMovies() async -> Result<MoviesResponse, Error> {
        let urlString = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_people=71580"
        guard let url = URL(string: urlString) else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        let headers: NETRequest.NETHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkM2E4ODU0ZTgxZGNiOTJjNjI3YWFjYjUwYTcwM2RiNyIsIm5iZiI6MTcyMzUxMjM5My40ODk5MjksInN1YiI6IjY2YmFiNTMzNWQ0ZWRhY2NlMzFhZWQyMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XAA4w_hucBqmsm6DYYuhlVgTC9YNM_v67DJjv4-KzS4",
            "accept": "application/json"
        ]
        
        let request = NETRequest(url: url, headers: headers)
        
        let result = await client.request(request)
        
        switch result {
        case .success(let response):
            return .success(response.value)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchSimilarMovies(movieId: Int) async -> Result<MoviesResponse, Error> {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/similar?language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        let headers: NETRequest.NETHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkM2E4ODU0ZTgxZGNiOTJjNjI3YWFjYjUwYTcwM2RiNyIsIm5iZiI6MTcyMzUxMjM5My40ODk5MjksInN1YiI6IjY2YmFiNTMzNWQ0ZWRhY2NlMzFhZWQyMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XAA4w_hucBqmsm6DYYuhlVgTC9YNM_v67DJjv4-KzS4",
            "accept": "application/json"
        ]
        
        let request = NETRequest(url: url, headers: headers)
        let result = await client.request(request)
        
        switch result {
        case .success(let similarMovies):
            return .success(similarMovies.value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
