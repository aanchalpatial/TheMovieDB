//
//  Endpoint.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation

struct Endpoint {

    static let base = "https://api.themoviedb.org/3"
    static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"

    enum type {
        case popular(Int)
        case getImage(String)
        case getSimilar(Int)

        var stringValue: String {
            switch self {
                case .popular(let page):
                    return Endpoint.base + "/movie/popular" + Endpoint.apiKeyParam + "&language=en-US" +
                        "&page=\(page)"
                case .getImage(let filePath):
                    return "https://image.tmdb.org/t/p/original/" + filePath
                case .getSimilar(let id):
                    return Endpoint.base + "/movie/\(id)/similar" + Endpoint.apiKeyParam
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
