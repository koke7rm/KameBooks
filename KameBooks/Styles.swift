//
//  Styles.swift
//  KameBooks
//
//  Created by Jorge Suárez on 12/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

/// Estilo de botón que hará un efecto de escalado al pulsar
struct TapEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct CustomRounderedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.lightGray)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
    }
}
