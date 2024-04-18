//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Павел Куба on 13.04.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTest: XCTestCase {
    func testingValiueInRange() throws {
        let array = [1, 1, 2, 3, 5]
        let value = array[2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testgetValueOutOfRange() throws {
        let array = [1, 1, 2, 3, 5]
        
        let value = array[safe: 20]
        
        XCTAssertNil(value)
    }
}
