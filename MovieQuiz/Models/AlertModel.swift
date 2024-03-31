//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Павел Куба on 30.03.2024.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: (() -> Void)?
}
