//
//  TetrisGameViewModel.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 18/06/2023.
//

import Foundation
import SwiftUI


class TetrisGameViewModel: ObservableObject {
    var numRows: Int
    var numColumns: Int
    @Published var gameBoard: [[TetrisGameSquare]] // Double array
    
    init(numRows: Int = 23, numColumns: Int = 10) {
        self.numRows = numRows
        self.numColumns = numColumns
        
        gameBoard = Array(repeating: Array(repeating: TetrisGameSquare(color: Color.tetrisBlack), count: numRows), count: numColumns)
    }
    
    func squareClicked(row: Int, column: Int) {
        print("Column: \(column), Row: \(row)")
        if gameBoard[column][row].color == Color.tetrisBlack {
            gameBoard[column][row].color = Color.tetrisRed
        } else {
            gameBoard[column][row].color = Color.tetrisBlack
        }
    }
}

struct TetrisGameSquare {
    var color: Color
}
