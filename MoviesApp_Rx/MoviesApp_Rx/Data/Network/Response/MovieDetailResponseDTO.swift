//
//  MovieDetailResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/31/24.
//

import Foundation

struct MovieDetailResponse: Decodable {
    let id: Int
    let title: String
    let genres: [GenreResponse]?
    let adult: Bool?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, video, genres, adult, popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDetailResponse {
    func toMovieDetail() -> MovieDetail {
        return MovieDetail(
            id: self.id,
            title: self.title,
            genres: toGenres(),
            adult: self.adult,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            releaseDate: self.releaseDate,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            popularity: self.popularity
        )
    }
    
    func toGenres() -> [Genre]? {
        return self.genres?.compactMap { toGenre(genreResponse: $0) }
    }

    func toGenre(genreResponse: GenreResponse) -> Genre? {
        return Genre(id: genreResponse.id, name: genreResponse.name)
    }
}
