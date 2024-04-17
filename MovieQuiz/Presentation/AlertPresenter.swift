//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Павел Куба on 30.03.2024.
//

import Foundation
import UIKit

class AlertPresenter {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func present(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion?()
        }

        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
