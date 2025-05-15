import SwiftUI
import ARKit
import RealityKit

struct ARContainerView: UIViewRepresentable {
    @EnvironmentObject var coordinator: ARCoordinator

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)

        coordinator.setup(arView: arView)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

