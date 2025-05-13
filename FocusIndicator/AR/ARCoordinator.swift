//
//  ARCoordinator.swift
//  FocusIndicator
//
//  Created by João Vitor Lima Mergulhão on 25/02/25.
//
import ARKit
import RealityKit

class ARCoordinator: NSObject, ARSessionDelegate{
    var arView: ARView?
    var focusIndicator: PlaneIndicator?
    let robotAnchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z: 0))
    
    @MainActor func setup(arView: ARView){
        self.arView = arView
        
        focusIndicator = PlaneIndicator()
        focusIndicator?.setup(arView: arView)
    }
    
    func placeRobot(){
        guard let focusIndicator else { return }
        
        
        if focusIndicator.state == .detecting{
            guard let arView,
            let position = focusIndicator.position,
            let orientation = focusIndicator.orientation else {return}
            
            var robotEntity = ModelEntity()
            
            do{
                robotEntity = try Entity.loadModel(named: "robot")
            } catch let error{
                print("Não foi possível carregar o modelo: \(error)")
            }
            
            robotEntity.position = position
            robotEntity.orientation = orientation
            
            robotAnchor.addChild(robotEntity)
            arView.scene.addAnchor(robotAnchor)
        }
    }
}
