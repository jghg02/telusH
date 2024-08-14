//
//  MainCoordinator.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showMovieDetail(movie: Movie) {
        let movieDetailViewController = MovieDetailViewController(movie: movie)
        navigationController.pushViewController(movieDetailViewController, animated: true)
    }
    
}
