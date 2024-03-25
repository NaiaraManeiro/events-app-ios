//
//  NotificationManager.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import SwiftUI
import UserNotifications

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var randomNumber: Int = 0

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermissions()
    }

    func scheduleLocalNotification() {
        // Generar un número aleatorio entre 0 y 999999
        randomNumber = Int.random(in: 0...999999)
        
        print("OTP number: \(randomNumber)")

        // Crear el contenido de la notificación
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("loginOTP", comment: "")
        content.body = NSLocalizedString("loginOTPText", comment: "") + "\(randomNumber)"
        content.sound = UNNotificationSound.default

        // Configurar el desencadenador de la notificación para que se muestre inmediatamente
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        // Crear la solicitud de notificación
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Agregar la solicitud al centro de notificaciones
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error al programar la notificación: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle notification presentation in the foreground
        completionHandler([.sound, .badge])
    }
    
    func checkMatchingNumber(userInput: Int) -> Bool {
        return userInput == randomNumber
    }
}
