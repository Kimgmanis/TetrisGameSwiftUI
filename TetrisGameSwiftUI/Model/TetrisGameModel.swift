//
//  TetrisGameModel.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 18/06/2023.
//

import Foundation

class TetrisGameModel: ObservableObject {
    var numRows: Int
    var numColumns: Int
    @Published var gameBoard: [[TetrisGameBlock?]] // Double array
    @Published var tetromino: Teteromino?
    
    var timer: Timer?
    var speed: Double
    
    init(numRows: Int = 23, numColumns: Int = 10) {
        self.numRows = numRows
        self.numColumns = numColumns
        
        gameBoard = Array(repeating: Array(repeating: nil, count: numRows), count: numColumns)
        speed = 0.1
        resumeGame()
    }
    
    func blockClicked(row: Int, column: Int) {
        print("Column: \(column), Row: \(row)")
        if gameBoard[column][row] == nil {
            gameBoard[column][row] = TetrisGameBlock(blockType: BlockType.allCases.randomElement()!) // Picks random element from all cases
        } else {
            gameBoard[column][row] = nil
        }
    }
    
    func resumeGame() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: runEngine)
    }
    
    func pauseGame() {
        timer?.invalidate()
    }
    
    func runEngine(timer: Timer) {
        // Spawn a new block
        guard let currentTetromino = tetromino else { // check
            print("Spawing a new Tetromino")
            tetromino = Teteromino.createNewTetromino(numRows: numRows, numColumns: numColumns) // Creates tetromino
            if !isValidTetromino(testTetromino: tetromino!) {
                print("Game over!")
                pauseGame()
            }
            return
        }
        
        // Move block down to next position
        let newTetromino = currentTetromino.moveBy(row: -1, column: 0)
        if isValidTetromino(testTetromino: newTetromino) {
            print("Moving Tetromnio down")
            tetromino = newTetromino
            return
        }
        
        // Check if block needs to be placed
        print("Placing Tetromino")
        placeTetromino()
    }
    
    // Checking if the rows/columns are within the bounds of the board
    func isValidTetromino(testTetromino: Teteromino) -> Bool {
        for block in testTetromino.blocks {
            let row = testTetromino.origin.row + block.row
            if row < 0 || row >= numRows { return false }
            
            let column = testTetromino.origin.column + block.column
            if column < 0 || column >= numColumns { return false}
            
            if gameBoard[column][row] != nil {return false}
        }
        return true
    }
    
    func placeTetromino() {
        guard let currentTetromino = tetromino else {
            return
        }
        
        for block in currentTetromino.blocks {
            let row = currentTetromino.origin.row + block.row
            if row < 0 || row >= numRows { continue }
            
            let column = currentTetromino.origin.column + block.column
            if column < 0 || column >= numColumns { continue }
            
            gameBoard[column][row] = TetrisGameBlock(blockType: currentTetromino.blockType)
        }
        
        tetromino = nil
    }
}

struct TetrisGameBlock {
    var blockType: BlockType
}

enum BlockType: CaseIterable {
    case i, t, o, j, l, s, z
}

struct Teteromino { // Block structure
    var origin: BlockLocation
    var blockType: BlockType
    var blocks: [BlockLocation] {
        return Teteromino.getBlocks(blockType: blockType)
    }
    
    func moveBy(row: Int, column: Int) -> Teteromino {
        let newOrigin = BlockLocation(row: origin.row + row, column: origin.column + column)
        return Teteromino(origin: newOrigin, blockType: blockType)
    }
    
    // Block types
    static func getBlocks(blockType: BlockType) -> [BlockLocation] {
        switch blockType {
        case .i:
            return [ // i block
                BlockLocation(row: 0, column: -1),
                BlockLocation(row: 0, column: 0),
                BlockLocation(row: 0, column: 1),
                BlockLocation(row: 0, column: 2)]
        case .o:
            return [
                BlockLocation(row: 0, column: 0),
                BlockLocation(row: 0, column: 1),
                BlockLocation(row: 1, column: 1),
                BlockLocation(row: 1, column: 0)]
        case .t:
            return [ // i block
                BlockLocation(row: 0, column: -1),
                BlockLocation(row: 0, column: 0),
                BlockLocation(row: 0, column: 1),
                BlockLocation(row: 1, column: 0)]
        case .j:
            return [
                BlockLocation(row: 1, column: -1),
                BlockLocation(row: 0, column: -1),
                BlockLocation(row: 0, column: 0),
                BlockLocation(row: 0, column: 1)]
        case .l:
            return [ // i block
                BlockLocation(row: 0, column: -1),
                BlockLocation(row: 0, column: 0),
                BlockLocation(row: 0, column: 1),
                BlockLocation(row: 1, column: 1)]
        case .s:
            return [
                BlockLocation(row: 0, column: -1),
                BlockLocation(row: 0, column: 0),
                BlockLocation(row: 1, column: 0),
                BlockLocation(row: 1, column: 1)]
        case .z:
            return [
                BlockLocation(row: -1, column: 0),
                BlockLocation(row: 0, column: 0),
                BlockLocation(row: 0, column: -1),
                BlockLocation(row: -1, column: 1)]
        }
    }
    
    static func createNewTetromino(numRows: Int, numColumns: Int) -> Teteromino {
        let blockType = BlockType.allCases.randomElement()!
        
        var maxRow = 0
        for block in getBlocks(blockType: blockType) {
            maxRow = max(maxRow, block.row)
        }
        
        let origin = BlockLocation(row: numRows - 1 - maxRow, column: (numColumns-1)/2)
        return Teteromino(origin: origin, blockType: blockType)
    }
}

struct BlockLocation {
    var row: Int
    var column: Int
}
