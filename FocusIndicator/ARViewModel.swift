//
//  ARViewModel.swift
//  FocusIndicator
//
//  Created by João Vitor Lima Mergulhão on 13/05/25.
//
import SwiftUI
import ARKit
import RealityKit

class ARViewModel: ObservableObject {
    private let coordinator = ARCoordinator()
    
    @MainActor func setup(arView: ARView) {
        coordinator.setup(arView: arView)
    }
    
    func placeRobot() {
        coordinator.placeRobot()
    }
}
