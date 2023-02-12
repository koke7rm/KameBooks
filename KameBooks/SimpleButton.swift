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
    let bacgkroundColor: Color
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 18))
                .bold()
                .textCase(.uppercase)
                .foregroundColor(foregroundColor)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(bacgkroundColor)
                .cornerRadius(8)
        }
        .buttonStyle(TapEffect())
    }
}

struct SimpleButton_Previews: PreviewProvider {
    static var previews: some View {
        SimpleButton(text: "Test", foregroundColor: .white, bacgkroundColor: .gold, action: {})
    }
}

