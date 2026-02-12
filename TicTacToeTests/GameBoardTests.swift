//
//  GameBoardTests.swift
//  TicTacToeTests
//

import XCTest
@testable import TicTacToe

final class GameBoardTests: XCTestCase {
    
    func testEmptyBoard() {
        let board = GameBoard()
        XCTAssertTrue(board.isEmpty)
        XCTAssertFalse(board.isFull)
        XCTAssertNil(board.checkWinner())
    }
    
    func testPlacePlayer() {
        var board = GameBoard()
        XCTAssertTrue(board.placePlayer(.x, at: 0))
        XCTAssertEqual(board.getPlayer(at: 0), .x)
        XCTAssertFalse(board.placePlayer(.o, at: 0)) // Already occupied
    }
    
    func testWinConditions() {
        var board = GameBoard()
        
        // Test row win
        _ = board.placePlayer(.x, at: 0)
        _ = board.placePlayer(.x, at: 1)
        _ = board.placePlayer(.x, at: 2)
        XCTAssertEqual(board.checkWinner(), .x)
    }
    
    func testDraw() {
        var board = GameBoard()
        
        // Fill board with no winner
        let moves: [(Player, Int)] = [
            (.x, 0), (.o, 1), (.x, 2),
            (.o, 3), (.o, 4), (.x, 5),
            (.o, 6), (.x, 7), (.o, 8)
        ]
        
        for (player, position) in moves {
            _ = board.placePlayer(player, at: position)
        }
        
        XCTAssertTrue(board.isDraw())
        XCTAssertNil(board.checkWinner())
    }
}
