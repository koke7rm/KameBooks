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
            Color.white
                .ignoresSafeArea()
            VStack {
                userImage
                
                VStack {
                    formFields
                    
                    SimpleButton(text: "SAVE".localized, foregroundColor: .black, backroundColor: .gold) {
                        Task{
                            await profileVM.saveData()
                        }
                    }
                    .opacity(profileVM.validateFields() ? 1 : 0.6)
                    .disabled(!profileVM.validateFields())
                    .padding()
                }
                .padding()
            }
            .frame(maxHeight: .infinity)
        }
        .overlay{
            SimpleCustomAlert(isPresented: $profileVM.showSuccessAlert, title: "APP_NAME".localized, description: "PROFILE_UPDATE_OK".localized) {
                dismiss()
            }
            if profileVM.loading {
                LoaderView()
                    .transition(.opacity)
            }
        }
        .alert("ERROR_TITLE".localized, isPresented: $profileVM.showErrorAlert) {
            Button(action: {}) {
                Text("CLOSE".localized)
                    .textCase(.uppercase)
            }
        } message: {
            Text(profileVM.errorMsg)
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
                    .foregroundColor(.blackLight)
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
            CustomTextField(text: $profileVM.name, field: "NAME".localized, placeholder: "AUTH_NAME_PLACEHOLDER".localized, validation: profileVM.validateEmpty)
                .textInputAutocapitalization(.words)
                .textContentType(.name)
            CustomTextField(text: $profileVM.mail, field: "EMAIL".localized, placeholder: "AUTH_MAIL_PLACEHOLDER".localized)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .disabled(true)
            CustomTextField(text: $profileVM.address, field: "ADDRESS".localized, placeholder: "AUTH_ADDRESS_PLACEHOLDER".localized, validation: profileVM.validateEmpty)
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
