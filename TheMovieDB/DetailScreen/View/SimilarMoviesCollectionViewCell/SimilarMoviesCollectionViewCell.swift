//
//  SimilarMoviesCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Properties
    static let identifier = "SimilarMoviesCollectionViewCell"
    let cornerRadius: CGFloat = 5

    // MARK: - View Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerRadiusAndBorders()
    }

    // MARK: - Methods
    func configureCornerRadiusAndBorders() {
        imageView.layer.cornerRadius = cornerRadius * 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    static func nib() -> UINib {
        return UINib(nibName: "SimilarMoviesCollectionViewCell", bundle: nil)
    }

    func configure(movie: MovieResponse){
        if let path = movie.posterPath {
            let url = Endpoint.type.getImage(path).url
            imageView.downloaded(from: url)
        }
    }
}
