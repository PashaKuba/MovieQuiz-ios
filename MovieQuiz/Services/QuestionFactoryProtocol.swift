//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Павел Куба on 24.03.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
    func setup(delegate: QuestionFactoryDelegate)
}
