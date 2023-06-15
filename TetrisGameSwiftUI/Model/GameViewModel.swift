//
//  GameViewModel.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 15/06/2023.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var gameBoard: [[Block?]]

    init() {
        gameBoard = Array(repeating: Array(repeating: nil, count: 10), count: 20)
    }

    struct Block {
        var x: Int
        var y: Int
        var color: Color
    }

    struct Piece {
        var blocks: [Block]
    }
}
