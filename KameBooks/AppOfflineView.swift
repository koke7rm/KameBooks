//
//  AppOfflineView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct AppOfflineView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.7))
                .ignoresSafeArea()
            VStack {
                Text("NETWORKCONNECTION_TITLE".localized)
                    .font(.headline)
                    .foregroundColor(.blueMain)
                Text("NETWORKCONNECTION_SUBTITLE".localized)
                    .foregroundColor(.gold)
            }
        }
    }
}

struct AppOfflineView_Previews: PreviewProvider {
    static var previews: some View {
        AppOfflineView()
    }
}
