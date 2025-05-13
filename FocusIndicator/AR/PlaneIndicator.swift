import ARKit
import RealityKit

enum FocusState{
    case searching
    case detecting
    case disabled
}

class PlaneIndicator: NSObject, ARSessionDelegate {
    private var target: ModelEntity?
    private var arView: ARView?
    
    private var isSearching: Bool = true
    private var isDetecting: Bool = true
    
    var state: FocusState = .searching
    
    var position: SIMD3<Float>?{
        return target?.position
    }
    
    var orientation: simd_quatf?{
        return target?.orientation
    }
    
    @MainActor func setup(arView: ARView) {
        self.arView = arView
        arView.session.delegate = self // Definindo como delegate da sessão ARKit
        
        let planeMesh = MeshResource.generatePlane(width: 0.3, depth: 0.3)
        
        target = ModelEntity(mesh: planeMesh)
        target?.isEnabled = false
        
        target?.components[CollisionComponent.self] = CollisionComponent(shapes: [.generateBox(size: [0.3, 0.001, 0.3])])
        
        guard let target else { return }
        
        let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, 0)) // Inicialmente na origem
        anchor.addChild(target)
        arView.scene.addAnchor(anchor)
        
        applyTexture("target")
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        Task { @MainActor in
            updateFocusIndicator()
        }
    }

    @MainActor func updateFocusIndicator() {
        guard let arView, let target else { return }

        let viewportCenter = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        let raycastResults = arView.raycast(from: viewportCenter, allowing: .estimatedPlane, alignment: .any)

        if let result = raycastResults.first {
            let worldPos = result.worldTransform.translation
            let worldRotation = simd_quatf(result.worldTransform)

            target.position = worldPos
            target.orientation = worldRotation
            target.isEnabled = true
            
            if isSearching {
                isDetecting = true
                isSearching = false
                
                state = .detecting
                applyTexture("target")
            }
            
        } else {
            // Define a posição fixa à frente do celular
            let cameraTransform = arView.cameraTransform
            let forward = cameraTransform.matrix.forward * 1 // Distância de 1m à frente
            let fixedPosition = cameraTransform.translation + forward
            let additionalRotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(1, 0, 0))

            target.position = fixedPosition
            target.orientation = cameraTransform.rotation * additionalRotation
            target.isEnabled = true

            if isDetecting{
                isDetecting = false
                isSearching = true
                
                state = .searching
                applyTexture("square")
            }
        }
    }
    
    @MainActor func disable() {
        target?.isEnabled = false
        state = .disabled
    }
    
    @MainActor func enable() {
        target?.isEnabled = true
        state = .searching
    }
    
    @MainActor func applyTexture(_ name: String) {
        guard let target, let texture = imageToTexture(named: name) else { return }
        
        var material = UnlitMaterial()
        material.color = SimpleMaterial.BaseColor(tint: .white, texture: MaterialParameters.Texture(texture))
        material.blending = .transparent(opacity: 1.0)
        
        target.model?.materials = [material]
    }
}
