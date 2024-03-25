//
//  AuthManager.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()

    // Función para verificar el inicio de sesión
    func loginUser(type: String, email: String, password: String?) -> String {
        guard let user = DatabaseManager.shared.findUser(email: email) else {
            // Usuario no encontrado
            return "noUser"
        }
        
        if (type == "emailPass") {
            // Obtener el hash de la contraseña proporcionada con el salt almacenado
            let hashedPassword = DatabaseManager.shared.hashPassword(password!, salt: user.salt)

            // Comparar el hash calculado con el hash almacenado en la base de datos
            if hashedPassword == user.pass {
                // Contraseña válida
                return user.email
            } else {
                // Contraseña no válida
                return "wrongPass"
            }
        } else {
            return user.email
        }
    }
    
    func emailValid(emailInput: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: emailInput)
    }
    
    func passValid(passInput: String) -> Bool {
        let pass = !passInput.isEmpty
        let passNum = passInput.count > 7
        return pass && passNum
    }
    
    func usernameValid(usernameInput: String) -> Bool {
        let username = !usernameInput.isEmpty
        return username
    }
}
