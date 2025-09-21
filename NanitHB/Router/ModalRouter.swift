//
//  ModalRouter.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import Combine
import Foundation

public final class ModalRouter<Route: Hashable, ModalRoute: Identifiable>: Router<Route> {
    
    @Published public var presentedModal: ModalRoute? = nil
    
    public override init() {
        super.init()
    }
    
    public func presentModal(_ modal: ModalRoute) {
        presentedModal = modal
    }

    public func dismissModal() {
        presentedModal = nil
    }

}
