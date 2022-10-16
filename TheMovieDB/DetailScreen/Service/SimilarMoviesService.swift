//
//  SimilarMoviesService.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation

final class SimilarMoviesService: TMDBClient {

    // MARK: - Methods
    func getSimilar(movieId: Int, completion: @escaping ([MovieResponse]?, Error?)->Void) {
        taskForGETRequest(url: Endpoint.type.getSimilar(movieId).url, responseType: MoviesList.self) {
            (responseObject, error) in
            if responseObject != nil {
                completion(responseObject!.results, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
