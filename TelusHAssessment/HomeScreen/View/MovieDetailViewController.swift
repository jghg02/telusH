//
//  MovieDetailViewController.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import UIKit

class MovieDetailViewController: UIViewController {
    let movie: Movie
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        return overlay
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let synopsisLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView(with: movie)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.addSubview(posterImageView)
        headerView.addSubview(overlayView)
        headerView.addSubview(titleLabel)
        view.addSubview(synopsisLabel)
        
        NSLayoutConstraint.activate([
            // Header view (Poster + Overlay)
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            posterImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: headerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // Title and genre labels
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            // Synopsis label
            synopsisLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            synopsisLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            synopsisLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureView(with movie: Movie) {
        titleLabel.text = movie.title
        synopsisLabel.text = movie.overview
        
        if let posterPath = movie.posterPath {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            loadImage(from: imageUrl)
        }
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }
    }
}
