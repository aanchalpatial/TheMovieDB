//
//  DetailScreenViewModel.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation
import UIKit

protocol DetailScreenViewUpdatable: AnyObject {
    
    func configureViews()
    func handleSimilarMovieResponse(similarMoviesList: [MovieResponse])
}

final class DetailScreenViewModel {

    // MARK: - Properties
    private weak var view: DetailScreenViewUpdatable?
    var movie: MovieResponse!
    private let similarMoviesService = SimilarMoviesService()
    var similarMovies = [MovieResponse]()

    // MARK: - Intialisation
    init(view: DetailScreenViewUpdatable, movie: MovieResponse) {
        self.view = view
        self.movie = movie
    }

    // MARK: - Methods
    func setupSimilarMovies() {
        view?.configureViews()
        similarMoviesService.getSimilar(movieId: Int(movie.id)) { [weak self](similarMoviesList, error) in
            guard let similarMoviesList = similarMoviesList else {
                print("Error returned from API: \(String(describing: error))")
                return
            }
            self?.similarMovies = similarMoviesList
            self?.view?.handleSimilarMovieResponse(similarMoviesList: similarMoviesList)
        }
    }
}

