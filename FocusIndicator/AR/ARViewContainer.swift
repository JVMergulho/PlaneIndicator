import SwiftUI
import ARKit
import RealityKit

struct ARContainerView: UIViewRepresentable{
    var arView: ARView!
    var coordinator = ARCoordinator()
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical, .horizontal]
        arView.session.run(configuration)
        
        //arView.session.delegate = coordinator
        coordinator.setup(arView: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
