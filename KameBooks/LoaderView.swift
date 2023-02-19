//
//  LoaderView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white.opacity(0.1))
                .ignoresSafeArea()
            VStack(spacing: 8) {
                ProgressView()
                    .tint(.black)
                    .padding(.top)
                Text("LOADING".localized)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.bottom)
                    .padding(.horizontal)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.gold)
            )
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
