//
//  HomeView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    let user = KameBooksKeyChain.shared.user
    var body: some View {
        Text(user?.name ?? "nada")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
