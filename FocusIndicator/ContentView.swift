//
//  ContentView.swift
//  FocusIndicator1
//
//  Created by João Vitor Lima Mergulhão on 24/02/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: ARCoordinator
    
    var isButtonDisabled: Bool {
        if coordinator.indicatorState != .detecting {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        ZStack {
            ARContainerView()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                
                Button(action:{
                    coordinator.placeRobot()
                }, label:{
                    Text("Add Robot")
                        .foregroundStyle(.white)
                        .bold()
                        .frame(width: 140, height: 60)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                })
                .opacity(isButtonDisabled ? 0.5 : 1)
                .disabled(isButtonDisabled)
                .padding(.bottom, 80)
            }
        }
    }
}
