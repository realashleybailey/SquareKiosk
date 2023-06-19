//
//  Counter.swift
//  AshleysParty
//
//  Created by Ashley Bailey on 15/12/2021.
//

import SwiftUI

struct Counter: View {
	
	var counter: Int
	var size: Int = 25
	
    var body: some View {
		VStack {
			ZStack {
				RoundedRectangle(cornerRadius: 4)
					.fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
				
				RoundedRectangle(cornerRadius: 4)
					.strokeBorder(Color(#colorLiteral(red: 0.5269474387168884, green: 0.5269474387168884, blue: 0.5269474387168884, alpha: 1)), lineWidth: 0.5)
				
				Text(String(self.counter))
					.font(.system(size: CGFloat(size - 9), weight: .medium))
					.foregroundColor(Color("primary"))
					.tracking(-0.28)
			}
			.frame(width: CGFloat(size), height: CGFloat(size))
		}
    }
}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
		Counter(counter: 5)
    }
}
