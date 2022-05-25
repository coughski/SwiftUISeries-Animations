//
//  ContentView.swift
//  SwiftUISeries-Animations
//
//  Created by Kuba Szulaczkowski on 5/24/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var filled = false
    @State private var isAnimating = false
    @State private var numberOfPresses = 0
    @State private var animationTimer = Foundation.Timer.publish(every: .infinity, tolerance: 0.1, on: .main, in: .common).autoconnect()
    @State private var fillColor: Color = .black
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(fillColor)
                .frame(width: 20, height: 20)
                .mask {
                    Image(systemName: filled ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 200, height: 200) // render higher resolution
                        .scaleEffect(1/10)
                        .frame(width: 20, height: 20) // but display it smaller
                }
                .scaleEffect(isAnimating ? 30 : 1)
                .rotationEffect(isAnimating ? Angle(degrees: 144) : .zero)
                .opacity(isAnimating ? 0.2 : 1)
                .onAppear {
                    animationTimer.upstream.connect().cancel()
                }
                .onTapGesture {
                    withAnimation(.spring().speed(0.7)) {
                        isAnimating = true
                        fillColor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                    }
                    animationTimer = Foundation.Timer.publish(every: 0.4, tolerance: 0.1, on: .main, in: .common).autoconnect()
                }
                .onLongPressGesture {
                    withAnimation {
                        filled = false
                        fillColor = .black
                        numberOfPresses -= 1
                    }
                }
                .onReceive(animationTimer) { _ in
                    withAnimation(.spring()) {
                        isAnimating = false
                        filled = true
                        numberOfPresses += 1
                    }
                    animationTimer.upstream.connect().cancel()
                }
            Text("\(numberOfPresses)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
