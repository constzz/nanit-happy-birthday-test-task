//
//  Router.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//


import Combine
import SwiftUI

@MainActor
open class Router<Route: Hashable>: ObservableObject {
    @Published public var path = NavigationPath()
    
    public init() {}
    
    private var stack: [Route] = []
    
    public func navigate(to route: Route) {
        path.append(route)
        stack.append(route)
    }
    
    public func setPath(to routes: [Route]) {
        self.stack.removeAll()
        var newPath = NavigationPath()
        for route in routes {
            newPath.append(route)
            self.stack.append(route)
        }
        path = newPath
    }
    
    public func navigateBack(screensCount: Int = 1) {
        path.removeLast(screensCount)
        stack.removeLast(screensCount)
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
        stack.removeAll()
    }
    
    public func isScreenInPath(_ route: Route) -> Bool {
        return stack.contains(where: { $0 == route })
    }
}    
