//
//  GameViewModel.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 15/06/2023.
//

import Foundation
import SwiftUI

// struct that represents each block in a Tetris piece
struct Block: Hashable, Identifiable {
    let id = UUID()
    var x: Int
    var y: Int
    var color: Color
}

// struct that represents a Tetris piece. Each piece is made up of four blocks
struct Piece {
    var blocks: [Block]
}

// Constants
let gameBoardWidth = 10
let gameBoardHeight = 20

// Handles game logic
class GameViewModel: ObservableObject {
    @Published var gameBoard: [[Block?]] = Array(repeating: Array(repeating: nil, count: gameBoardWidth),  count: gameBoardHeight)
    @Published var currentPiece: Piece? // Represents the piece that is falling
    @Published var nextPiece: Piece? // Next piece that will fall
    @Published var gameOver: Bool = false
    @Published var paused: Bool = false
    @Published var score: Int = 0
    @Published var highScore: Int = 0
    @Published var linesCleared: Int = 0
    
    private var timer: Timer? // Timer
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        gameBoard = Array(repeating: Array(repeating: nil, count: gameBoardWidth), count: gameBoardHeight)
        currentPiece = generateRandomPiece()
        nextPiece = generateRandomPiece()
        
        if !isValidPiece(currentPiece) {
            gameOver = true
            return
        }
        
        let level = linesCleared / 10
        let interval = max(0.1, 1 - Double(level) * 0.1)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if self.gameOver { // Game over
                self.highScore = max(self.highScore, self.score) // Update highScore
                self.timer?.invalidate() // Stops loop
            } else { // Move piece down every second
                self.movePieceDown()
            }
        }
    }
    
    // Generating random index and return Tetris piece based on index
    func generateRandomPiece() -> Piece {
        let randomIndex = Int.random(in: 0..<7)
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
        
        let color = colors.randomElement() ?? .red
        
        switch randomIndex {
        case 0:
            // I-block
            return Piece(blocks: [
                Block(x: 3, y: 0, color: color),
                Block(x: 4, y: 0, color: color),
                Block(x: 5, y: 0, color: color),
                Block(x: 6, y: 0, color: color)
            ])
        case 1:
            // J-block
            return Piece(blocks: [
                Block(x: 3, y: 0, color: color),
                Block(x: 3, y: 1, color: color),
                Block(x: 4, y: 1, color: color),
                Block(x: 5, y: 1, color: color)
            ])
        case 2:
            // L-block
            return Piece(blocks: [
                Block(x: 3, y: 1, color: color),
                Block(x: 4, y: 1, color: color),
                Block(x: 5, y: 1, color: color),
                Block(x: 5, y: 0, color: color)
            ])
        case 3:
            // O-block
            return Piece(blocks: [
                Block(x: 4, y: 0, color: color),
                Block(x: 5, y: 0, color: color),
                Block(x: 4, y: 1, color: color),
                Block(x: 5, y: 1, color: color)
            ])
        case 4:
            // S-block
            return Piece(blocks: [
                Block(x: 4, y: 1, color: color),
                Block(x: 5, y: 1, color: color),
                Block(x: 5, y: 0, color: color),
                Block(x: 6, y: 0, color: color)
            ])
        case 5:
            // T-block
            return Piece(blocks: [
                Block(x: 4, y: 0, color: color),
                Block(x: 3, y: 1, color: color),
                Block(x: 4, y: 1, color: color),
                Block(x: 5, y: 1, color: color)
            ])
        case 6:
            // Z-block
            return Piece(blocks: [
                Block(x: 4, y: 0, color: color),
                Block(x: 5, y: 0, color: color),
                Block(x: 5, y: 1, color: color),
                Block(x: 6, y: 1, color: color)
            ])
        default:
            return Piece(blocks: [])
        }
    }
    
    func movePieceDown() {
        guard let currentPiece = currentPiece else { return }
        
        let newBlocks = currentPiece.blocks.map { Block(x: $0.x, y: $0.y + 1, color: $0.color) }
        let newPiece = Piece(blocks: newBlocks)
        
        if isValidPiece(newPiece) {
            self.currentPiece = newPiece
            updateGameBoard()
        } else {
            for block in currentPiece.blocks {
                if block.y >= 0 && block.y < gameBoardHeight && block.x >= 0 && block.x < gameBoardWidth {
                    gameBoard[block.y][block.x] = block
                }
            }
            
            self.currentPiece = self.nextPiece
            self.nextPiece = generateRandomPiece()
            
            if !isValidPiece(currentPiece) {
                gameOver = true
                timer?.invalidate()
            }
            
            clearLines()
        }
    }
    
    func isValidPiece(_ piece: Piece?) -> Bool {
        guard let piece = piece else { return false }
        
        for block in piece.blocks {
            // Check if the block is outside the game board
            if block.x < 0 || block.x >= gameBoardWidth || block.y >= gameBoardHeight {
                return false
            }
            
            // Check if the block collides with an existing block
            if gameBoard[block.y][block.x] != nil {
                return false
            }
        }
        
        return true
    }
    
    func clearLines() {
        var linesCleared = 0
        var newGameBoard = [[Block?]](repeating: [Block?](repeating: nil, count: gameBoardWidth), count: gameBoardHeight)
        
        for y in (0..<gameBoardHeight).reversed() {
            let row = gameBoard[y]
            if row.allSatisfy({ $0 != nil }) {
                linesCleared += 1
            } else {
                newGameBoard[y + linesCleared] = row
            }
        }
        
        score += linesCleared * 100
        self.linesCleared += linesCleared
        
        gameBoard = newGameBoard
        
        if linesCleared > 0 {
            timer?.invalidate()
            let level = self.linesCleared / 10
            let interval = max(0.1, 1 - Double(level) * 0.1)
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.movePieceDown()
            }
        }
    }
    
    func movePieceLeft() {
        guard let currentPiece = currentPiece else { return }
        
        let newBlocks = currentPiece.blocks.map { Block(x: $0.x - 1, y: $0.y, color: $0.color) }
        let newPiece = Piece(blocks: newBlocks)
        
        if isValidPiece(newPiece) {
            self.currentPiece = newPiece
            updateGameBoard()
        }
    }
    
    func movePieceRight() {
        guard let currentPiece = currentPiece else { return }
        
        let newBlocks = currentPiece.blocks.map { Block(x: $0.x + 1, y: $0.y, color: $0.color) }
        let newPiece = Piece(blocks: newBlocks)
        
        if isValidPiece(newPiece) {
            self.currentPiece = newPiece
            updateGameBoard()
        }
    }
    
    func updateGameBoard() {
        gameBoard = Array(repeating: Array(repeating: nil, count: gameBoardWidth), count: gameBoardHeight)
        
        if let currentPiece = currentPiece {
            for block in currentPiece.blocks {
                if block.y >= 0 && block.y < gameBoardHeight && block.x >= 0 && block.x < gameBoardWidth {
                    gameBoard[block.y][block.x] = block
                }
            }
        }
    }
    
    func rotatePiece() {
        guard let currentPiece = currentPiece else { return }
        
        let newBlocks: [Block]
        
        switch currentPiece.blocks.count {
        case 4:
            // O-block: It does not rotate
            return
        case 2:
            // I-block: Rotate 90 degrees
            let centerBlock = currentPiece.blocks[1]
            newBlocks = currentPiece.blocks.map { block in
                let x = centerBlock.x - block.y + centerBlock.y
                let y = centerBlock.y + block.x - centerBlock.x
                return Block(x: x, y: y, color: block.color)
            }
        default:
            // J-block, L-block, S-block, T-block, Z-block: Rotate 90 degrees
            let centerBlock = currentPiece.blocks[1]
            newBlocks = currentPiece.blocks.map { block in
                let x = centerBlock.x - block.y + centerBlock.y
                let y = centerBlock.y + block.x - centerBlock.x
                return Block(x: x, y: y, color: block.color)
            }
        }
        
        let newPiece = Piece(blocks: newBlocks)
        
        if isValidPiece(newPiece) {
            self.currentPiece = newPiece
            updateGameBoard()
        }
    }
}
