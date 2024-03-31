//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Павел Куба on 30.03.2024.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    func isBetter(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
