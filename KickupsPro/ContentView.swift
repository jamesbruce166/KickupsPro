//
//  ContentView.swift
//  KickupsPro
//
//  Created by James Erringham-Bruce on 11/07/2021.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var gameScene = GameScene()
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
            
            VStack (alignment: .leading) {
                Text("High Score: \(gameScene.highScore)")
                    .font(.subheadline)
                    .padding(.leading)
                    .foregroundColor(.black)
                
                Text("Score: \(gameScene.currentScore)")
                    .font(.largeTitle)
                    .padding(.leading)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 50)
        }
        .ignoresSafeArea()
        .alert(item: $gameScene.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: { gameScene.reset() }))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
