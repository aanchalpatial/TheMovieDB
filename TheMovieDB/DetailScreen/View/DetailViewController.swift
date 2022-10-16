//
//  DetailViewController.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var similarMoviesLabel: UILabel!
    @IBOutlet private weak var similarMoviesCollectionView: UICollectionView!

    // MARK: - Properties
    private var viewModel: DetailScreenViewModel?
    var movie: MovieResponse!
    var posterImage: UIImage?
    let cornerRadius: CGFloat = 5
    
    init(movie: MovieResponse) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailScreenViewModel(view: self, movie: movie)
        configureLabels()
        configureImageView()
        configureNavigationTitle()
        if let image = posterImage {
            self.imageView.image = image
        } else {
            setupPosterImage()
        }
        viewModel?.setupSimilarMovies()
    }
    
    // MARK: - Methods
    func setupPosterImage() {
        if let path = movie.posterPath {
            let url = Endpoint.type.getImage(path).url
            imageView.downloaded(from: url)
        }
    }

    private func configureImageView(){
        imageView.alpha = 0.4
    }

    private func configureLabels() {
        similarMoviesLabel.layer.cornerRadius = cornerRadius
        similarMoviesLabel.clipsToBounds = true
        descriptionLabel.text = movie.overview
    }
    
    private func configureCollectionView() {
        similarMoviesCollectionView.delegate = self
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.backgroundColor = .none
        similarMoviesCollectionView.register(SimilarMoviesCollectionViewCell.nib(), forCellWithReuseIdentifier: SimilarMoviesCollectionViewCell.identifier)
        configureCollectionViewCellLayout()
    }

    private func configureCollectionViewCellLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: CGFloat(140), height: CGFloat(180))
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        similarMoviesCollectionView!.collectionViewLayout = layout
    }

    private func configureNavigationTitle() {
        self.title = movie.title
        navigationItem.largeTitleDisplayMode = .never
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        tlabel.text = self.title
        tlabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        tlabel.backgroundColor = UIColor.clear
        tlabel.numberOfLines = 0
        tlabel.textAlignment = .center
        self.navigationItem.titleView = tlabel
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.similarMovies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = similarMoviesCollectionView.dequeueReusableCell(withReuseIdentifier:
                                                                    SimilarMoviesCollectionViewCell.identifier,
                                                                   for: indexPath) as! SimilarMoviesCollectionViewCell
        if let movie = viewModel?.similarMovies[indexPath.row] {
            cell.configure(movie: movie)
        }
        return cell
    }
}

// MARK: - DetailScreenViewUpdatable
extension DetailViewController: DetailScreenViewUpdatable {

    func configureViews() {
        configureCollectionView()
    }

    func handleSimilarMovieResponse(similarMoviesList: [MovieResponse]) {
        DispatchQueue.main.async {
            if similarMoviesList.count == 0 {
                self.similarMoviesLabel.isHidden = true
            } else {
                self.similarMoviesLabel.isHidden = false
            }
            self.similarMoviesCollectionView.reloadData()
        }
    }
}
