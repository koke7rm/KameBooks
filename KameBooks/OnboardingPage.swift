//
//  OnboardingPage.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct OnboardingPage: View {
    
    let title: String
    let image: String
    let description: String
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                Image(image)
                    .resizable()
                    .scaledToFit()
                Text(description)
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
    }
}

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage(title: "Wellcome", image: "img_decision", description: "Instruction")
    }
}
