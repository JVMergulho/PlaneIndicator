//
//  ContentView.swift
//  FocusIndicator1
//
//  Created by João Vitor Lima Mergulhão on 24/02/25.
//

import SwiftUI

struct ContentView: View {
    var ARView = ARContainerView()
    
    var body: some View {
        ZStack{
            ARView
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                
                Button(action:{
                    ARView.coordinator.placeRobot()
                }, label:{
                    Text("Add Robot")
                        .foregroundStyle(.white)
                        .bold()
                        .frame(width: 140, height: 60)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                })
                .padding(.bottom, 80)
            }
        }
    }
}
