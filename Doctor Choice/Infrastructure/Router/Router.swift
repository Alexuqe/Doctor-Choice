import SwiftUI

protocol Routeble {
    var path: NavigationPath { get set }
    func push(to scene: AppScenes)
    func pop()
    func popToRoot()
}

@Observable
final class Router: Routeble {
    var path = NavigationPath()

    func push(to scene: AppScenes) {
        path.append(scene)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
