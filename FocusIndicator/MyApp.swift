
//  Created by João Vitor Lima Mergulhão on 24/02/25.
//

import SwiftUI

@main
struct MyApp: App {
    @StateObject var coordinator = ARCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
        }
    }
}
