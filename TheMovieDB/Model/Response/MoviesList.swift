//
//  MoviesList.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation

struct MoviesList: Codable {

    let page: Int
    let results: [MovieResponse]
    let totalPages: Int
    let totalResults: Int
}
