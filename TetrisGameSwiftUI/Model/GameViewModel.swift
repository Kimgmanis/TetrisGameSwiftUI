//
//  GameViewModel.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 15/06/2023.
//

import Foundation
import SwiftUI

// Handels game logic
class GameViewModel: ObservableObject {
    //The game board is a 2D array of blocks.
    @Published var gameBoard: [[Block?]]
    @Published var currentPiece: Piece? // Represents the piece that is falling
    @Published var nextPiece: Piece? // Next piece that will fall


    init() {
        gameBoard = Array(repeating: Array(repeating: nil, count: 10), count: 20)
    }
    
    // Checks for collision/within gameBoard
    func isValidPiece(_ piece: Piece) -> Bool {
        for block in piece.blocks {
            // Check if the block is outside the game board
            if block.x < 0 || block.x >= 10 || block.y < 0 || block.y >= 20 {
                return false
            }

            // Check if the block collides with an existing block
            if gameBoard[block.y][block.x] != nil {
                return false
            }
        }
        
        // if none of the blocks collide with a bloc kwe return true
        return true
    }

    // struct that will represent each block in a Tetris piece
    struct Block {
        var x: Int
        var y: Int
        var color: Color
    }

    // struct that will represent a Tetris piece. Each piece is made up of four blocks
    struct Piece {
        var blocks: [Block]
    }

    func movePieceLeft() {
        guard let currentPiece = currentPiece else { return }

        let newBlocks = currentPiece.blocks.map { Block(x: $0.x - 1, y: $0.y, color: $0.color) }
        let newPiece = Piece(blocks: newBlocks)

        if isValidPiece(newPiece) {
            self.currentPiece = newPiece
        }
    }

    func movePieceRight() {
        guard let currentPiece = currentPiece else { return }

        let newBlocks = currentPiece.blocks.map { Block(x: $0.x + 1, y: $0.y, color: $0.color) }
        let newPiece = Piece(blocks: newBlocks)

        if isValidPiece(newPiece) {
            self.currentPiece = newPiece
        }
    }


    func rotatePiece() {
        // TODO: Implement this
    }
    
    // Down by 1 row
    func movePieceDown() {
        guard let currentPiece = currentPiece else { return }
        
        // Creates a new piece
        let newBlocks = currentPiece.blocks.map { Block(x: $0.x, y: $0.y + 1, color: $0.color) }
        let newPiece = Piece(blocks: newBlocks)

        if isValidPiece(newPiece) {
            self.currentPiece = newPiece // Update position
        } else {
            for block in currentPiece.blocks {
                gameBoard[block.y][block.x] = block // Add block to gameBoard
            }
            
            // Continue to next piece
            self.currentPiece = nextPiece
            nextPiece = generateRandomPiece()
        }
    }


    func startNewGame() { // Initializes currentPiece and nextPiece and clears the gameBoard
        gameBoard = Array(repeating: Array(repeating: nil, count: 10), count: 20)
        currentPiece = generateRandomPiece()
        nextPiece = generateRandomPiece()
    }
    
    // Generating random index and return Tetris piece based on index
    func generateRandomPiece() -> Piece {
        let randomIndex = Int.random(in: 0..<7)
        let color = Color.red // You can change this to generate a random color if you want

        switch randomIndex {
            case 0:
                // I-block
                return Piece(blocks: [Block(x: 4, y: 0, color: color),
                                      Block(x: 5, y: 0, color: color),
                                      Block(x: 6, y: 0, color: color),
                                      Block(x: 7, y: 0, color: color)])
            case 1:
                // J-block
                return Piece(blocks: [Block(x: 4, y: 0, color: color),
                                      Block(x: 5, y: 0, color: color),
                                      Block(x: 6, y: 0, color: color),
                                      Block(x: 6, y: 1, color: color)])
            case 2:
                // L-block
                return Piece(blocks: [Block(x: 4, y: 0, color: color),
                                      Block(x: 5, y: 0, color: color),
                                      Block(x: 6, y: 0, color: color),
                                      Block(x: 4, y: 1, color: color)])
            case 3:
                // O-block
                return Piece(blocks: [Block(x: 4, y: 0, color: color),
                                      Block(x: 5, y: 0, color: color),
                                      Block(x: 4, y: 1, color: color),
                                      Block(x: 5, y: 1, color: color)])
            case 4:
                // S-block
                return Piece(blocks: [Block(x: 4, y: 1, color: color),
                                      Block(x: 5, y: 1, color: color),
                                      Block(x: 5, y: 0, color: color),
                                      Block(x: 6, y: 0, color: color)])
            case 5:
                // T-block
                return Piece(blocks: [Block(x: 4, y: 0, color: color),
                                      Block(x: 5, y: 0, color: color),
                                      Block(x: 6, y: 0, color: color),
                                      Block(x: 5, y: 1, color: color)])
            case 6:
                // Z-block
                return Piece(blocks: [Block(x: 4, y: 0, color: color),
                                      Block(x: 5, y: 0, color: color),
                                      Block(x: 5, y: 1, color: color),
                                      Block(x: 6, y: 1, color: color)])
            default:
                return Piece(blocks: [])
            }
    }
}
