//
//  ARCoordinator.swift
//  FocusIndicator
//
//  Created by João Vitor Lima Mergulhão on 25/02/25.
//
import ARKit
import RealityKit

class ARCoordinator: NSObject, ObservableObject, PlaneIndicatorDelegate{
  
    var planeIndicator: PlaneIndicator?
    
    var arView: ARView?
    let robotAnchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z: 0))
    
    @Published var indicatorState: IndicatorState = .disabled
    
    @MainActor
    func setup(arView: ARView){
        self.arView = arView
        
        planeIndicator = PlaneIndicator(arView: arView)
        planeIndicator?.setup()
        planeIndicator?.delegate = self
    }
    
    func placeRobot(){
        guard let planeIndicator else { return }
        
        if planeIndicator.state == .detecting{
            guard let arView,
            let position = planeIndicator.position,
            let orientation = planeIndicator.orientation else {return}
            
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
    
    func indicatorDidChangeState(newState: IndicatorState) {
        indicatorState = newState
        print("Novo estado: \(newState)")
    }
}
