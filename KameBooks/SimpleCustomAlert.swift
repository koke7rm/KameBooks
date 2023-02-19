//
//  SimpleCustomAlert.swift
//  KameBooks
//
//  Created by Jorge Suárez on 19/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct SimpleCustomAlert: View {
    
    @Binding var isPresented: Bool
    let title: String
    let description: String
    let action: () -> ()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(isPresented ? 0.8 : 0))
                .ignoresSafeArea()
                .gesture(TapGesture().onEnded({ _ in
                    isPresented = false
                }))
            VStack(spacing: 16) {
                Text(title)
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .bold()
                Text(description)
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                SimpleButton(text: "ACCEPT".localized, foregroundColor: .white, backroundColor: .gold) {
                    action()
                    isPresented = false
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .opacity(isPresented ? 1.0 : 0.0)
            .offset(y: isPresented ? 0.0 : 500)
            .padding(.horizontal, 30)
        }
        .animation(.default, value: isPresented)
    }
}

struct SimpleCustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCustomAlert(isPresented: .constant(true), title: "Title", description: "Description", action: {})
    }
}
