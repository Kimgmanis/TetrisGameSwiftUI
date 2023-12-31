//
//  TetrisGameView.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 18/06/2023.
//

import SwiftUI

struct TetrisGameView: View {
    @ObservedObject var tetrisGame = TetrisGameViewModel()
    
    var body: some View {
        GeometryReader {(geometry: GeometryProxy) in
            self.drawBoard(boundingRect: geometry.size)
        }
    }
    
    func drawBoard(boundingRect: CGSize) -> some View {
        let columns = self.tetrisGame.numColumns
        let rows = self.tetrisGame.numRows
        let blocksize = min(boundingRect.width/CGFloat(columns), boundingRect.height/CGFloat(rows))
        let xoffset = (boundingRect.width - blocksize*CGFloat(columns))/2
        let yoffset = (boundingRect.height - blocksize*CGFloat(rows))/2
        
        return ForEach(0...columns-1, id:\.self) { (column:Int) in
            ForEach(0...rows-1, id:\.self) { (row:Int) in
                Path { path in
                    let x = xoffset + blocksize * CGFloat(column)
                    let y = boundingRect.height - yoffset - blocksize * CGFloat(row+1)
                    
                    let rect = CGRect(x: x, y: y, width: blocksize, height: blocksize)
                    path.addRect(rect)
                }
                .fill(self.tetrisGame.gameBoard[column][row].color)
                .onTapGesture {
                    self.tetrisGame.squareClicked(row: row, column: column)
                }
            }
        }
    }
}

struct TetrisGameView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisGameView()
    }
}
