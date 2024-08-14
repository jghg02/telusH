//
//  Coordinator.swift
//  TelusHAssessment
//
//  Created by Josue Hernandez on 2024-08-12.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
