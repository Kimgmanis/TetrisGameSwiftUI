//
//  GameView.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 15/06/2023.
//

import SwiftUI
// GameView will display the game board
struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ForEach(0..<viewModel.gameBoard.count, id: \.self) { i in
            HStack {
                ForEach(0..<viewModel.gameBoard[i].count, id: \.self) { j in
                    Rectangle() // Represents a block block
                        .fill(viewModel.gameBoard[i][j]?.color ?? Color.clear) // blockcolor or clear color
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
