//
//  AuthView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI


struct AuthView: View {
    
    @Binding var screen: Screens
    
    var body: some View {
        VStack {
            Button {
                screen = .register
            } label: {
                Text("Crear cuenta")
            }
            .buttonStyle(.bordered)
            .tint(.gold)
            Button {
                print("Register")
            } label: {
                Text("Crear cuenta")
            }
            .buttonStyle(.bordered)
            .tint(.gold)
            
            Button {
                print("Register")
            } label: {
                Text("Crear cuenta")
            }
            .buttonStyle(.bordered)
            .tint(.gold)
        }

    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(screen: .constant(.auth))
    }
}
