//
//  MovieListResponseDTO.swift
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
            genreIds: movieResponse.genreIds,
            adult: movieResponse.adult,
            overview: movieResponse.overview,
            posterPath: movieResponse.posterPath,
            backdropPath: movieResponse.backdropPath,
            releaseDate: movieResponse.releaseDate,
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

struct MovieResponse: Decodable {
    let id: Int
    let title: String
    let originalTitle: String?
    let originalLanguage: String?
    let genreIds: [Int]?
    let adult: Bool?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, video, adult, popularity
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
