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
        VStack {
            GameView(viewModel: gameViewModel)
            VStack{ // Controls
                NextPieceView(piece: gameViewModel.nextPiece ?? Piece(blocks: [])) // Displays next piece
                HStack{
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
                            gameViewModel.rotatePiece()
                        }) {
                            Image(systemName: "rotate.right")
                        }.padding()
                    }
                    HStack{
                        Button(action: {
                            gameViewModel.movePieceLeft()
                        }) {
                            Image(systemName: "arrow.left")
                        }.padding()
                        Button(action: {
                            gameViewModel.movePieceDown()
                        }) {
                            Image(systemName: "arrow.down")
                        }.padding()
                        Button(action: {
                            gameViewModel.movePieceRight()
                        }) {
                            Image(systemName: "arrow.right")
                        }.padding()
                    }
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
