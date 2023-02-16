//
//  Profile.swift
//  KameBooks
//
//  Created by Jorge Suárez on 14/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI

struct Profile: View {
    
    @StateObject var profileVM = ProfileViewModel()
    
    @Binding var screen: Screens
    @State var presentEditProfile = false
    @AppStorage("isGuest") var isGuest = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if let image = profileVM.newPhoto {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .background {
                            Color.gray.opacity(0.2)
                        }
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding()
                        .background {
                            Color.gray.opacity(0.2)
                        }
                        .clipShape(Circle())
                }
                VStack {
                    Text(profileVM.userData?.name ?? "Invitado")
                    Text(profileVM.userData?.email ?? "-")
                }
            }
            Button {
                presentEditProfile.toggle()
            } label: {
                Text("Editar Mi perfil")
            }
            .buttonStyle(.bordered)
            Button {
                screen = .auth
                KameBooksKeyChain.shared.deleteUser()
                isGuest = false
            } label: {
                if isGuest {
                    Text("Iniciar sesión")
                } else {
                    Text("Cerrar sesión")
                }
            }
            .buttonStyle(.bordered)
        }
        .navigationDestination(isPresented: $presentEditProfile) {
            EditProfileView()
                .environmentObject(profileVM)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(screen: .constant(.home))
    }
}
