//
//  PopularMoviesService.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation

final class PopularMoviesService: TMDBClient {

    // MARK: - Methods
    func getPopular(page: Int, completion: @escaping ([MovieResponse]?, Error?)->Void) {
        taskForGETRequest(url: Endpoint.type.popular(page).url, responseType: MoviesList.self) {
            (responseObject, error) in
            if responseObject != nil {
                completion(responseObject!.results, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
