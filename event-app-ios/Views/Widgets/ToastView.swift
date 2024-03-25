//
//  ToastView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import SwiftUI

struct ToastView<Presenting>: View where Presenting: View {
    @Binding var isPresented: Bool
    let presenting: () -> Presenting
    let text: String

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()
                    .blur(radius: self.isPresented ? 1.0 : 0)
                    .animation(.easeInOut(duration: 0.5))

                VStack {
                    Text(self.text)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(10)
                }
                .opacity(self.isPresented ? 1 : 0)
                .animation(.easeInOut(duration: 0.5))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isPresented = false
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.1)
            }
        }
    }
}
