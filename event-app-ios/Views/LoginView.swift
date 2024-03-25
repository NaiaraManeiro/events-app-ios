//
//  LoginView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import SwiftUI
import Combine
import LocalAuthentication

struct LoginView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject private var notificationManager = NotificationManager()
    
    @State private var emailInput: String = ""
    @State private var passInput: String = ""
    
    @State private var isEmailValid: Bool = false
    @State private var isPassValid: Bool = false
    
    @State private var textInvalidPass: String = "invalidPass"
    
    @State private var rememberIsCheched: Bool = false

    @State private var isShowingAlert = false
    
    @State private var shouldNavigate = false
    @State private var tabviewParameter: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var randomNumber: Int = 0
    @State private var numberText: String = ""
    @State private var alertType: Int = 1
    @State private var otpTries: Int = 0
    @State private var showToast = false
    @State private var showToastManyTries = false
    
    @State private var reloadFlag = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                HStack {
                    Spacer()
                    Button(action: {
                        LocalizationService.shared.language = .spanish
                    }) {
                        Text("ES")
                            .foregroundColor(AppColors.primaryColor)
                            .bold()
                    }
                    Text("|")
                    Button(action: {
                        LocalizationService.shared.language = .english_us
                    }) {
                        Text("EN")
                            .foregroundColor(AppColors.primaryColor)
                            .bold()
                    }
                }
                
                TextField("emailText".localized(language), text: $emailInput)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onReceive(Just(emailInput)) { newEmail in
                        isEmailValid = AuthManager.shared.emailValid(emailInput: emailInput)
                    }
                
                if !isEmailValid {
                    Text("invalidEmail".localized(language))
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                SecureField("passText".localized(language), text: $passInput)
                    .textContentType(.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onReceive(Just(passInput)) { newPass in
                        isPassValid = AuthManager.shared.passValid(passInput: passInput)
                        if !isPassValid {
                            textInvalidPass = "invalidPass"
                        }
                    }
                
                if !isPassValid {
                    Text(textInvalidPass.localized(language))
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Toggle(isOn: $rememberIsCheched) {
                    Text("rememberBtn".localized(language))
                        .foregroundColor(AppColors.primaryColor)
                        .bold()
                }
                .padding(.horizontal)
                
                NavigationLink(destination: TabViewMain(emailUsuario: $tabviewParameter), isActive: $shouldNavigate) {
                    EmptyView()
                }
                
                Button(action: {
                    if (isEmailValid && isPassValid) {
                        let message: String = AuthManager.shared.loginUser(type: "emailPass", email: emailInput, password: passInput)
                        if (message == "noUser") {
                            isShowingAlert = true
                            alertType = 1
                        } else if (message == "wrongPass") {
                            passInput = ""
                            textInvalidPass = "wrongPass"
                        }
                        else {
                            //Cuando todo está bien el error es el nombre del usuario (email)
                            tabviewParameter = message
                            
                            if otpTries == 0 {
                                DispatchQueue.main.async {
                                    notificationManager.scheduleLocalNotification()
                                }
                            }
                            
                            alertType = 2
                            isShowingAlert = true
                        }
                    }
                }) {
                    Text("loginBtn".localized(language))
                        .bold()
                }.alert(
                    Text((alertType == 1) ? "loginDialogTitle".localized(language) : "loginOTP".localized(language)),
                    isPresented: $isShowingAlert
                ) {
                    if (alertType == 2) {
                        TextField("Enter text", text: $numberText)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.primary)
                            .background(Color(UIColor.systemBackground))
                    }
                    
                    Button("loginDialogBtn2".localized(language), role: .cancel) {
                        isShowingAlert = false
                    }
                    Button((alertType == 1) ? "loginDialogBtn1".localized(language) : "OK") {
                        if (alertType == 1) {
                            DatabaseManager.shared.insertUser(email: emailInput, pass: passInput)
                        } else {
                            if let number = Int(numberText) {
                                if notificationManager.checkMatchingNumber(userInput: number) {
                                    // Save the rememberMe value to UserDefaults
                                    UserDefaults.standard.set(rememberIsCheched, forKey: "RememberMe")
                                    if rememberIsCheched {
                                        UserDefaults.standard.set(tabviewParameter, forKey: "RememberUserEmail")
                                    }
                                    
                                    shouldNavigate = true
                                    otpTries = 0
                                } else {
                                    otpTries += 1
                                    
                                    if (otpTries != 3) {
                                        self.showToast = true
                                    }
                        
                                    if (otpTries == 3) {
                                        self.showToastManyTries = true
                                        
                                        otpTries = 0
                                    }
                                }
                            } else {
                                otpTries += 1
                                
                                if (otpTries != 3) {
                                    self.showToast = true
                                }
                    
                                if (otpTries == 3) {
                                    self.showToastManyTries = true
                                    
                                    otpTries = 0
                                }
                            }
                        }
                    }
                } message: {
                   Text((alertType == 1) ? "" : "loginOTPText".localized(language))
                }
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(AppColors.primaryColor)
                .foregroundColor(.white)
                .disabled(!isEmailValid || !isPassValid)
                
                VStack{
                    Button(action: {
                        authenticateWithBiometrics(email: emailInput)
                    }) {
                        Image(systemName: "touchid")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }.disabled(!isEmailValid)
                    
                    if (showToast) {
                        ToastView(isPresented: $showToast, presenting: {
                            Text("loginOtpTryAgain".localized(language))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.secondary)
                                .cornerRadius(10)
                        }, text: "loginOtpTryAgain".localized(language))
                    }
                    
                    if (showToastManyTries) {
                        ToastView(isPresented: $showToastManyTries, presenting: {
                            Text("loginOtpManyTries".localized(language))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.secondary)
                                .cornerRadius(10)
                        }, text: "loginOtpManyTries".localized(language))
                    }
                }
            }.padding()
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Authentication Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func authenticateWithBiometrics(email: String) {
        let context = LAContext()

        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access the app"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful
                        if (isEmailValid) {
                            let message: String = AuthManager.shared.loginUser(type: "biometric", email: email, password: nil)
                            if (message == "noUser") {
                                self.isShowingAlert = true
                            } else {
                                //Cuando todo está bien el error es el nombre del usuario (email)
                                self.tabviewParameter = message
                                
                                // Save the rememberMe value to UserDefaults
                                UserDefaults.standard.set(self.rememberIsCheched, forKey: "RememberMe")
                                if self.rememberIsCheched {
                                    UserDefaults.standard.set(message, forKey: "RememberUserEmail")
                                }
                                
                                self.shouldNavigate = true
                            }
                        }
                    } else {
                        // Authentication failed
                        self.alertMessage = authenticationError?.localizedDescription ?? "Unknown error"
                        self.showAlert = true
                    }
                }
            }
        } else {
            // Biometrics not available or not configured
            self.alertMessage = "Biometrics not available or not configured"
            self.showAlert = true
        }
    }
}
