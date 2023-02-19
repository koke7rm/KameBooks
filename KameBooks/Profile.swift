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
        ZStack {
            Color.blackLight
                .ignoresSafeArea()
            VStack {
                headerInfo
                
                if !isGuest {
                    SimpleButton(text: "PROFILE_EDIT_PROFILE".localized, foregroundColor: .black, backroundColor: .gold) {
                        presentEditProfile.toggle()
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom)
                }
                Divider()
                historyInfo
                
                Spacer()
                
                Text(String(format: "PROFILE_VERSION".localized, UIApplication.appVersion ?? "-", Date.now.showOnlyYear))
                    .foregroundColor(.black)
                
                Spacer()
                Button {
                    screen = .auth
                    KameBooksKeyChain.shared.deleteUser()
                } label: {
                    if isGuest {
                        Text("PROFILE_LOGIN".localized)
                    } else {
                        Text("PROFILE_LOGOUT".localized)
                    }
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .background(Color.white)
            .padding(.top)
        }
        .sheet(isPresented: $presentEditProfile, content: {
            EditProfileView()
                .environmentObject(profileVM)
        })
        .alert("ERROR_TITLE".localized, isPresented: $profileVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(profileVM.errorMsg)
        }
        .overlay {
            if profileVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }
    }
    
    var headerInfo: some View {
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
                Text(profileVM.userData?.name ?? "GUEST".localized)
                    .font(.title2)
                    .bold()
                Text(profileVM.userData?.email ?? "")
            }
            .padding()
            Spacer()
        }
        .padding()
    }
    
    var historyInfo: some View {
        
        VStack(alignment: .leading) {
            HistorySection(section: "PROFILE_BOOKS_READ".localized, info: "\(profileVM.userHistory?.readed.count ?? 0)")
            
            Divider()
            
            HistorySection(section: "PROFILE_BOOKS_PURCHASED".localized, info: "\(profileVM.userHistory?.ordered.count ?? 0)")
            Divider()
        }
    }
    
    struct HistorySection: View {
        
        let section: String
        let info: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(section)
                    .font(.title3)
                    .bold()
                Text(info)
                    .font(.title)
            }
            .padding()
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(screen: .constant(.home))
    }
}
