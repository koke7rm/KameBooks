//
//  CustomSearchBar.swift
//  KameBooks
//
//  Created by Jorge Suárez on 18/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct CustomSearchBar: View {
    @FocusState var focusField: Bool
    
    @Binding var searchText: String
    @Binding var showSearch: Bool
    let placeHolder: String
    let action: () -> ()
    
    var body: some View {
        HStack {
            TextField("HOME_SEARCH_PLACEHOLDER".localized, text: $searchText)
                .textFieldStyle(CustomRounderedTextFieldStyle())
                .focused($focusField)
            if showSearch {
                Button {
                    action()
                    focusField = false
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gold)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding()
        .background(Color.blackLight)
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(searchText: .constant(""), showSearch: .constant(true), placeHolder: "Buscar...", action: {})
    }
}
