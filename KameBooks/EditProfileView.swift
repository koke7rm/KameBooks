//
//  EditProfileView.swift
//  KameBooks
//
//  Created by Jorge Suárez on 16/2/23.
//  Copyright © 2023 Trantor S.L. All rights reserved.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @EnvironmentObject var profileVM: ProfileViewModel
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                userImage
                
                VStack {
                    formFields
                    
                    SimpleButton(text: "SAVE".localized, foregroundColor: .black, backroundColor: .gold) {
                        profileVM.saveData()
                    }
                    .opacity(profileVM.validateFields() ? 1 : 0.6)
                    .disabled(!profileVM.validateFields())
                    .padding()
                }
                .padding()
            }
        }
        .alert("APP_NAME".localized, isPresented: $profileVM.showSuccessAlert) {
            Button {
                dismiss()
            } label: {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text("PROFILE_UPDATE_OK".localized)
        }
    }
    
    var userImage: some View {
        VStack {
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
            PhotosPicker(selection: $profileVM.photoItem, matching: .images) {
                Label("PROFILE_EDIT_IMAGE".localized, systemImage: "photo")
            }
            .buttonStyle(.bordered)
            .foregroundColor(.black)
        }
    }
    
    var formFields: some View {
        VStack(spacing: 16) {
            CustomTextField(text: $profileVM.name, field: "NAME".localized, placeholder: "AUTH_NAME_PLACEHOLDER".localized)
                .textInputAutocapitalization(.words)
                .textContentType(.name)
            CustomTextField(text: $profileVM.mail, field: "EMAIL".localized, placeholder: "AUTH_MAIL_PLACEHOLDER".localized)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .disabled(true)
            CustomTextField(text: $profileVM.address, field: "ADDRESS".localized, placeholder: "AUTH_ADDRESS_PLACEHOLDER".localized)
                .textContentType(.streetAddressLine1)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(ProfileViewModel())
    }
}
