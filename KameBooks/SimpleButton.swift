//
//  SimpleButton.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct SimpleButton: View {
    
    let text: String
    let foregroundColor: Color
    let backroundColor: Color
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .bold()
                .textCase(.uppercase)
                .padding(.horizontal)
                .foregroundColor(foregroundColor)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(backroundColor)
                .cornerRadius(8)
        }
        .buttonStyle(TapEffect())
    }
}

struct SimpleButton_Previews: PreviewProvider {
    static var previews: some View {
        SimpleButton(text: "Test", foregroundColor: .white, backroundColor: .gold, action: {})
    }
}

