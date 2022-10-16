//
//  HomeTableViewCell.swift
//  TheMovieDB
//
//  Created by Aanchal Patial on 16/10/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    
    // MARK: - Properties
    private let apiClient = TMDBClient()
    var thisMovie: MovieResponse?
    static let identifier = "HomeTableViewCell"
    let cornerRadius: CGFloat = 5
    
    
    // MARK: - View Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thisMovie = nil
        titleLabel?.text = nil
        yearLabel?.text = nil
        descriptionLabel.text = nil
        indexLabel.text = nil
        myImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerRadiusAndBorders()
    }

    // MARK: - Methods
    private func configureCornerRadiusAndBorders() {
        myImageView.layer.cornerRadius = cornerRadius * 2
        myImageView.clipsToBounds = true
        myImageView.layer.borderWidth = 2
        myImageView.layer.borderColor = UIColor.lightGray.cgColor
        myImageView.layer.shouldRasterize = true

        indexLabel.layer.cornerRadius = cornerRadius * 2
        indexLabel.clipsToBounds = true
        indexLabel.layer.shouldRasterize = true

        titleLabel.layer.cornerRadius = 5
        titleLabel.clipsToBounds = true
        titleLabel.layer.shouldRasterize = true

        descriptionLabel.layer.cornerRadius = cornerRadius
        descriptionLabel.clipsToBounds = true
        descriptionLabel.layer.shouldRasterize = true

        yearLabel.layer.cornerRadius = cornerRadius
        yearLabel.clipsToBounds = true
        yearLabel.layer.shouldRasterize = true
    }
    
    func configure(with movie: MovieResponse, row: Int) {
        thisMovie = movie
        titleLabel?.text = movie.title
        yearLabel?.text = movie.releaseYear
        descriptionLabel.text = movie.overview
        indexLabel.text = String(row + 1)
        indexLabel.alpha = 1.0
        if let path = movie.posterPath {
            let url = Endpoint.type.getImage(path).url
            myImageView.downloaded(from: url)
        } else {
            myImageView.image = UIImage(named: "Placeholder")
        }
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
