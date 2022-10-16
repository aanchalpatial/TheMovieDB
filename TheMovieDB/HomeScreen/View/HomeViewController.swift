//
//  HomeViewController.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import UIKit

enum LoadingViewType {
    case middleActivityIndicator
    case bottomActivityIndicator
}

enum APICalledVia {
    case viaReachingTableViewBottom
    case viaViewDidLoad
}

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var middleActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var viewModel: HomeScreenViewModel?
    var selectedIndex = 0
    var refreshControl = UIRefreshControl()
    private var movies = [MovieResponse]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Movies"
        viewModel = HomeScreenViewModel(view: self)
        middleActivityIndicator.isHidden = true
        bottomActivityIndicator.isHidden = true
        configureTableView()
        viewModel?.fetchMovies()
    }
    
    // MARK: - Methods
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as! HomeTableViewCell
        cell.configure(with: movies[indexPath.row], row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsScreen = DetailViewController(movie: movies[indexPath.row])
        navigationController?.pushViewController(movieDetailsScreen, animated: true)
    }
}

// MARK: - HomeScreenViewUpdatable
extension HomeViewController: HomeScreenViewUpdatable {
    
    func reloadView(with movies: [MovieResponse]) {
        self.movies = movies
        tableView.reloadData()
    }

    @objc func imgTap(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    func animateLoadingView(type: LoadingViewType, startAnimating: Bool) {
        switch type {
            case .middleActivityIndicator:
            if startAnimating {
                middleActivityIndicator.isHidden = false
                middleActivityIndicator.startAnimating()
            } else {
                middleActivityIndicator.isHidden = true
                middleActivityIndicator.stopAnimating()
            }
        case .bottomActivityIndicator:
            if startAnimating {
                bottomActivityIndicator.isHidden = false
                bottomActivityIndicator.startAnimating()
            } else {
                bottomActivityIndicator.isHidden = true
                bottomActivityIndicator.stopAnimating()
            }
        }
    }
}
