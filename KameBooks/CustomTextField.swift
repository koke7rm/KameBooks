//
//  CustomTextField.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    @State var message = ""
    @State var error = false
    let field: String
    let placeholder: String
    var validation:((String) -> String?)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(field)
                .font(.headline)
                .padding(.leading)
                .foregroundColor(.black)
            TextField(placeholder, text: $text)
                .foregroundColor(.black)
                .padding(.horizontal)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .environment(\.colorScheme, .light)
                .frame(height: 40)
                .onChange(of: text) { newValue in
                    if let validation, let message = validation(newValue) {
                        self.message = message
                        self.error = true
                    } else {
                        self.error = false
                    }
                }
            if error {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant(""), field: "Name", placeholder: "Name")
    }
}
