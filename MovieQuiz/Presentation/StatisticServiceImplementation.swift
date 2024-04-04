//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Павел Куба on 30.03.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
            case correct, total, bestGame, gamesCount
        }

        private let userDefaults = UserDefaults.standard

        var totalAccuracy: Double {
            get {
                let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
                let total = userDefaults.integer(forKey: Keys.total.rawValue)
                return total > 0 ? Double(correct) / Double(total) : 0.0
            }
        }

        var gamesCount: Int {
            get {
                return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            }
            set {
                userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            }
        }

        var bestGame: GameRecord {
            get {
                guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                      let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                    return GameRecord(correct: 0, total: 0, date: Date())
                }
                return record
            }
            set {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    print("Невозможно сохранить результат")
                    return
                }
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }

        func store(correct count: Int, total amount: Int) {
            let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
            
            if newGameRecord.isBetter(self.bestGame) {
                self.bestGame = newGameRecord
            }
            let currentGamesCount = self.gamesCount
            self.gamesCount = currentGamesCount + 1
            let currentCorrect = userDefaults.integer(forKey: Keys.correct.rawValue) + count
            let currentTotal = userDefaults.integer(forKey: Keys.total.rawValue) + amount
            userDefaults.set(currentCorrect, forKey: Keys.correct.rawValue)
            userDefaults.set(currentTotal, forKey: Keys.total.rawValue)
        }
    }
