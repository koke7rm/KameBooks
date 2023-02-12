//
//  OnboardingView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI


struct OnboardingView: View {
    
    @State var selection = 0
    @Binding var screen: Screens
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                TabView(selection: $selection) {
                    OnboardingPage(title: "¿No te decides?", image: "img_decision", description: "Puedes revisar nuestro amplio catálogo de libros sin necesidad de registrate")
                        .tag(0)
                    OnboardingPage(title: "Registrate y a leer", image: "img_reading", description: "Compra los libros que quieras y te los enviamos a casa sin coste.")
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .animation(.easeInOut, value: selection) // 2
                
                Button {
                    if selection == 0 {
                        selection = 1
                    } else {
                        screen = .auth
                        isFirstLaunch = false
                    }
                } label: {
                    Text("Next")
                        .foregroundColor(.black)
                        .bold()
                }
                .buttonStyle(.bordered)
                .tint(.gold)
            }
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(screen: .constant(.auth))
    }
}

