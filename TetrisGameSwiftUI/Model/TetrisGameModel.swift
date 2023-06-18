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
    
    init(numRows: Int = 23, numColumns: Int = 10) {
        self.numRows = numRows
        self.numColumns = numColumns
        
        gameBoard = Array(repeating: Array(repeating: nil, count: numRows), count: numColumns)
        tetromino = Teteromino(origin: BlockLocation(row: 22, column: 4), blockType: .i)
    }
    
    func blockClicked(row: Int, column: Int) {
        print("Column: \(column), Row: \(row)")
        if gameBoard[column][row] == nil {
            gameBoard[column][row] = TetrisGameBlock(blockType: BlockType.allCases.randomElement()!) // Picks random element from all cases
        } else {
            gameBoard[column][row] = nil
        }
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
        [ // i block ----
            BlockLocation(row: 0, column: -1),
            BlockLocation(row: 0, column: 0),
            BlockLocation(row: 0, column: 1),
            BlockLocation(row: 0, column: 2),
        ]
    }
}

struct BlockLocation {
    var row: Int
    var column: Int
}
