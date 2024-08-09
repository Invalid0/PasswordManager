//
//  AddPasswordScreeen.swift
//  PasswordManager
//
//  Created by Darshan on 09/08/24.
//

import SwiftUI
import CryptoKit

struct AddPasswordScreeen: View {
    @State private var accountName: String = ""
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    TextField("Account Name", text: $accountName)
                        .font(.system(size: 16))
                        .padding()
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
                        .padding()

                    TextField("Username/ Email", text: $userName)
                        .font(.system(size: 16))
                        .padding()
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
                        .padding()

                    SecureField("Password", text: $password)
                        .font(.system(size: 16))
                        .padding()
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
                        .padding()

                    Button(action: {
                        if accountName.isEmpty || userName.isEmpty || password.isEmpty {
                            alertMessage = "All fields must be filled"
                            showAlert = true
                        } else {
                            CoreDataManager.shared.addAccount(accountName: accountName, usernameEmail: userName, password: password)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color("AddbuttonColor"))
                            .frame(height: 60)
                            .overlay {
                                Text("Add New Account")
                                    .foregroundColor(.white)
                            }
                    }
                    .padding()
                    .cornerRadius(12.0)
                    .padding()
                    .frame(height: 80)
                }
                .background(Color("AddAccountColor"))
            }
            .background(Color("AddAccountColor"))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AddPasswordScreeen()
}

