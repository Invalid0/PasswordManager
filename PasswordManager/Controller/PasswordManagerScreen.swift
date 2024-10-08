//
//  PasswordManagerScreen.swift
//  PasswordManager
//
//  Created by Darshan on 09/08/24.
//
import SwiftUI

struct PasswordManagerScreen: View {
    @State private var accounts: [Account] = []
    @State private var selectedAccount: Account?
    @State private var showingDetail = false
    @State private var showingAddPasswordScreen = false

    var body: some View {
        NavigationStack {
            ZStack {
                if accounts.isEmpty {
                    Text("Add Account")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(accounts) { account in
                        Button(action: {
                            print("Button pressed for account: \(account)")
                            selectedAccount = account
                            print("Selected account set to: \(String(describing: selectedAccount))")
                            showingDetail = true
                        }) {
                            HStack(spacing: 20) {
                                Text(account.accountName)
                                    .font(.title2)
                                    .padding()
                                    .frame(width: 170, alignment: .leading)
                                    .foregroundColor(.black)
                                Text("*****")
                                    .kerning(3)
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Image(systemName: "arrowshape.right.fill")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .sheet(isPresented: $showingDetail) {
                        if let account = selectedAccount {
                            AccountDetailsScreen(account: account)
                                .presentationDetents([.fraction(0.75)])
                                .onDisappear {
                                    accounts = CoreDataManager.shared.fetchAccounts()
                                }
                        } else {
                            Text("Select another item. We are facing an issue fetching the item.")
                                .foregroundColor(.red)
                        }
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddPasswordScreen = true
                        }) {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color.blue)
                                .frame(width: 80, height: 80)
                                .padding(15)
                                .overlay {
                                    Image(systemName: "plus.app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                }
                        }
                        .padding(.bottom, 10)
                        .sheet(isPresented: $showingAddPasswordScreen, onDismiss: {
                            accounts = CoreDataManager.shared.fetchAccounts()
                        }) {
                            AddPasswordScreeen()
                                .presentationDetents([.fraction(0.50), .medium])
                                .presentationDragIndicator(.visible)
                                .background(Color("TextFieldColor"))
                        }
                    }
                }
            }
            .navigationTitle("Password Manager")
            .navigationBarHidden(true)
        }
        .onAppear {
            if accounts.isEmpty{
                addDefaultAccounts()
            }
            accounts = CoreDataManager.shared.fetchAccounts()
            print("Fetched Accounts onAppear: \(accounts)")
        }
    }
    
    // Adding Default Data
    func addDefaultAccounts(){
        CoreDataManager.shared.addAccount(accountName: "Google", usernameEmail: "google@gmail.com", password: "google@5566")
        CoreDataManager.shared.addAccount(accountName: "LikedIn", usernameEmail: "linkedIn@gmail.com", password: "linkedIn@5566")
        CoreDataManager.shared.addAccount(accountName: "Twitter", usernameEmail: "twitter@gmail.com", password: "twitter@5566")
        CoreDataManager.shared.addAccount(accountName: "Facebook", usernameEmail: "facebook@gmail.com", password: "facebook@5566")
        CoreDataManager.shared.addAccount(accountName: "Instagram", usernameEmail: "instagram@gmail.com", password: "instagram@5566")
    }
}

#Preview {
    PasswordManagerScreen()
}
