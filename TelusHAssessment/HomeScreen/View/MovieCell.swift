//
//  MovieCell.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import UIKit

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let gradientOverlay: UIView = {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.6, 1.0]
        overlay.layer.insertSublayer(gradient, at: 0)
        return overlay
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black // Set to black since it's no longer on the image
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel) // Moved outside of the image
        thumbnailImageView.addSubview(gradientOverlay)
        setupConstraints()
        setupAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 100),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 150),
            
            gradientOverlay.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            gradientOverlay.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.4),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // Center vertically to align with image
        ])
    }
    
    private func setupAnimations() {
        // Initial state for animation
        self.alpha = 0.0
        thumbnailImageView.alpha = 0.0
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        if let posterPath = movie.posterPath {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            loadImage(from: imageUrl)
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
            thumbnailImageView.alpha = 1.0 // Ensure alpha is set to 1 if no image loading is needed
        }
        
        // Animate cell fade-in
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1.0
        }
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                    // Animate image fade-in
                    UIView.animate(withDuration: 0.2) {
                        self.thumbnailImageView.alpha = 1.0
                    }
                }
            }
        }
    }
}
