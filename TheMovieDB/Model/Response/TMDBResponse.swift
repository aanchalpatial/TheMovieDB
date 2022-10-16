//
//  TMDBResponse.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation

struct TMDBResponse: Codable {
    
    let statusCode: Int?
    let statusMessage: String?
}

extension TMDBResponse: LocalizedError {

    var errorDescription: String? {
        return statusMessage
    }
}
