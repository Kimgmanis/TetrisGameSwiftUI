//
//  ContentView.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 15/06/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameViewModel = GameViewModel()
    
    var body: some View {
        TetrisGameView()
    }
}

/*
// GameView will display the game board
struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            ForEach(0..<viewModel.gameBoard.count, id: \.self) { i in
                HStack {
                    ForEach(0..<viewModel.gameBoard[i].count, id: \.self) { j in
                        Rectangle()
                            .fill(viewModel.gameBoard[i][j]?.color ?? Color.clear)
                            .frame(width: 20, height: 20)
                            .id(viewModel.gameBoard[i][j]?.id) // Provide a unique key
                    }
                }
            }
        }
    }
}*/

// Displays next piece
/*struct NextPieceView: View {
    var piece: Piece

    var body: some View {
        VStack {
            ForEach(piece.blocks, id: \.self) { block in
                HStack {
                    Rectangle()
                        .fill(block.color)
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}*/

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    /*VStack {
        Text("High Score: \(gameViewModel.highScore)")
        ZStack {
            GameView(viewModel: gameViewModel)
            NextPieceView(piece: gameViewModel.nextPiece ?? Piece(blocks: [])) // next piece
            VStack {
                Spacer()
                HStack {
                    Button(action: { // Pause
                        gameViewModel.paused.toggle()
                    }) {
                        Text(gameViewModel.paused ? "Resume" : "Pause")
                    }.padding()
                    Spacer()
                    Button(action: {
                        gameViewModel.startNewGame()
                    }) {
                        Text("New Game")
                    }.padding()
                }
                VStack {
                    HStack{
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.1)) {
                                gameViewModel.rotatePiece()
                            }
                        }) {
                            Image(systemName: "rotate.right")
                        }.padding()
                    }
                    HStack{
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.1)) {
                                gameViewModel.movePieceLeft()
                            }
                        }) {
                            Image(systemName: "arrow.left")
                        }.padding()
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.1)) {
                                gameViewModel.movePieceDown()
                            }
                        }) {
                            Image(systemName: "arrow.down")
                        }.padding()
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.1)) {
                                gameViewModel.movePieceRight()
                            }
                        }) {
                            Image(systemName: "arrow.right")
                        }.padding()
                    }
                }
            }
        }
    }
}*/
