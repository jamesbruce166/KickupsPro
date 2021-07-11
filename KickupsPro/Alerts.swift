//
//  Alerts.swift
//  QuizMe
//
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let gameOver = AlertItem(title: Text("Game Over"), message: Text("The ball hit the floor!"), buttonTitle: Text("Try Again."))
}


