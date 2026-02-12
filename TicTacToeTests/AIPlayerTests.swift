//
//  AIPlayerTests.swift
//  TicTacToeTests
//

import XCTest
@testable import TicTacToe

final class AIPlayerTests: XCTestCase {
    
    func testEasyAI() {
        let ai = AIPlayer()
        let board = GameBoard()
        
        let move = ai.getBestMove(board: board, player: .o, difficulty: .easy)
        XCTAssertNotNil(move)
        XCTAssertTrue((0...8).contains(move!))
    }
    
    func testHardAINeverLoses() {
        let ai = AIPlayer()
        
        // Test that hard AI blocks winning moves
        var board = GameBoard()
        _ = board.placePlayer(.x, at: 0) // X
        _ = board.placePlayer(.x, at: 1) // X
        // Board: X X _
        //        _ _ _  
        //        _ _ _
        
        let move = ai.getBestMove(board: board, player: .o, difficulty: .hard)
        XCTAssertEqual(move, 2) // Should block the win at position 2
    }
}
