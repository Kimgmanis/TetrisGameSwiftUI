//
//  NextPieceView.swift
//  TetrisGameSwiftUI
//
//  Created by Kim Keiser on 15/06/2023.
//

import SwiftUI

// Displays next piece
    struct NextPieceView: View {
        var piece: Piece
        
        var body: some View {
            ForEach(piece.blocks, id: \.self) { block in
                Rectangle() // for each block of the piece
                    .fill(block.color)
                    .frame(width: 20, height: 20)
                    .offset(x: CGFloat(block.x * 20), y: CGFloat(block.y * 20))
            }
        }
    }

struct NextPieceView_Previews: PreviewProvider {
    static var previews: some View {
        NextPieceView(piece: Piece(blocks: []))
    }
}
