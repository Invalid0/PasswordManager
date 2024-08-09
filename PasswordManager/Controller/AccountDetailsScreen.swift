//
//  AccountDetailsScreen.swift
//  PasswordManager
//
//  Created by Darshan on 09/08/24.
//
import SwiftUI
import CryptoKit

struct AccountDetailsScreen: View {
    @State private var accountName: String
    @State private var usernameEmail: String
    @State private var password: String
    @State private var isPasswordVisible: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    private let accountId: UUID
   
    init(account: Account) {
        _accountName = State(initialValue: account.accountName)
        _usernameEmail = State(initialValue: account.username_email)
        _password = State(initialValue: account.password)
      
        self.accountId = account.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Details")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
                .padding([.top, .horizontal])

            VStack(alignment: .leading, spacing: 10) {
                Text("Account Name")
                    .foregroundColor(.gray)
                TextField("Account Name", text: $accountName)
                    .font(.system(size: 16))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.bottom, 10)

                Text("Username/ Email")
                    .foregroundColor(.gray)
                TextField("Username/ Email", text: $usernameEmail)
                    .font(.system(size: 16))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.bottom, 10)

                Text("Password")
                    .foregroundColor(.gray)
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    } else {
                        SecureField("Password", text: $password)
                            .font(.system(size: 16))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.blue)
                            .padding(.leading, 5)
                    }
                }
            }
            .padding(.horizontal)

            HStack {
                Button(action: {
                    if accountName.isEmpty || usernameEmail.isEmpty || password.isEmpty {
                        alertMessage = "All fields must be filled"
                        showAlert = true
                    } else {

                        CoreDataManager.shared.updateAccount(id: accountId, accountName: accountName, usernameEmail: usernameEmail, password: password)
                        alertMessage = "Value Updated"
                       
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color("AddbuttonColor"))
                        .frame(height: 60)
                        .overlay {
                            Text("Edit")
                                .foregroundColor(.white)
                        }
                }
                .padding(.trailing)

                Button(action: {
                    showAlert = true
                    alertMessage = "Are you sure you want to delete this account?"
                }) {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.red)
                        .frame(height: 60)
                        .overlay {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertMessage),
                primaryButton: .destructive(Text("Delete")) {
                    if alertMessage == "Are you sure you want to delete this account?" {
                        CoreDataManager.shared.deleteAccount(id: accountId)
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    AccountDetailsScreen(account: Account(id: UUID(), accountName: "Sample Account", username_email: "user@example.com", password: "password123"))
}

