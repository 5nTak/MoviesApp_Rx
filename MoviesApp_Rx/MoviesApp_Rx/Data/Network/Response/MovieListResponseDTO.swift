//
//  MovieDiscoveryResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/12/04.
//

import Foundation

struct MovieListResponse: Decodable {
    let results: [MovieResponse]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension MovieListResponse {
    func toMovie(movieResponse: MovieResponse) -> Movie? {
        return Movie(
            id: movieResponse.id,
            title: movieResponse.title,
            originalTitle: movieResponse.originalTitle,
            originalLanguage: movieResponse.originalLanguage,
            genres: movieResponse.genres,
            adult: movieResponse.adult,
            overview: movieResponse.overview,
            posterPath: movieResponse.posterPath,
            backdropPath: movieResponse.backdropPath,
            releaseData: movieResponse.releaseDate,
            video: movieResponse.video,
            voteAverage: movieResponse.voteAverage,
            voteCount: movieResponse.voteCount,
            popularity: movieResponse.popularity
        )
    }
    
    func toMovies() -> [Movie] {
        return self.results.compactMap { toMovie(movieResponse: $0) }
    }
    
    func toMovieList() -> MovieList {
        return MovieList(
            results: self.toMovies(),
            page: self.page,
            totalPages: self.totalPages,
            totalResults: self.totalResults
        )
    }
}
