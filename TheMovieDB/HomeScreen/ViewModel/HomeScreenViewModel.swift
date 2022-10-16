//
//  HomeScreenViewModel.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import Foundation

protocol HomeScreenViewUpdatable: AnyObject {
    func reloadView(with movies: [MovieResponse])
    func animateLoadingView(type: LoadingViewType, startAnimating: Bool)
}

final class HomeScreenViewModel {

    // MARK: - Properties
    private weak var view: HomeScreenViewUpdatable?
    private let popularMoviesService = PopularMoviesService()
    var currentPopularPage = 1

    // MARK: - Initialisation
    init(view: HomeScreenViewUpdatable) {
        self.view = view
    }

    // MARK: - Methods
    func fetchMovies() {
        if Reachability.isConnectedToNetwork(){
            fetchPopularMoviesFromAPI(apiCallMethod: .viaViewDidLoad)
        } else{
            // TODO: - show error popup to user
        }
    }

    func fetchPopularMoviesFromAPI(apiCallMethod: APICalledVia) {
        switch apiCallMethod {
            case .viaViewDidLoad:
                currentPopularPage = 1
                view?.animateLoadingView(type: .middleActivityIndicator, startAnimating: true)
            popularMoviesService.getPopular(page: self.currentPopularPage) {
                    [weak self](popularList, error) in
                    guard let self = self,
                          let popularList = popularList else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.view?.animateLoadingView(type: .middleActivityIndicator, startAnimating: false)
                        self.view?.reloadView(with: popularList)
                    }
                }
            case .viaReachingTableViewBottom:
                print("viaReachingTableViewBottom")
                // TODO: - Implement pagination logic here
        }
    }
}


