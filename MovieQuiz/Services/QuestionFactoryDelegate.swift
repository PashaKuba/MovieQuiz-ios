//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Павел Куба on 28.03.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

