//
//  MovieResponse.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation

struct MovieResponse: Codable, Equatable {

    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    let releaseYearLength = 4
    var releaseYear: String {
        return String(releaseDate.prefix(releaseYearLength))
    }
}
