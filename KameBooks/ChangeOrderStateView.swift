//
//  ChangeOrderStateView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 26/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct ChangeOrderStateView: View {
    
    @Environment (\.dismiss) var dismiss
    
    @Binding var setState: String
    let action: () -> ()
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundColor(.blackLight)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
            Spacer()
            Text("HOMEWORKER_CHANGE_ORDER_STATE_TITLE".localized)
                .font(.title)
                .foregroundColor(.blackLight)
                .padding(.bottom, 20)
            VStack(alignment: .leading, spacing: 16) {
                ForEach(OrderState.allCases, id: \.rawValue) { state in
                    Button {
                        setState = state.rawValue
                    } label: {
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: setState == state.rawValue ? "circle.fill" : "circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gold)
                            Text(state.rawValue.capitalized)
                                .font(.system(size: 21))
                                .foregroundColor(.blackLight)
                        }
                    }
                }
            }
            
            SimpleButton(text: "SAVE".localized, foregroundColor: .blackLight, backroundColor: .gold) {
                action()
                dismiss()
            }
            .padding()
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}

struct ChangeOrderStateView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeOrderStateView(setState: .constant(""), action: {})
    }
}
