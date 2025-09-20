//
//  UIApplication+Ext.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import UIKit

extension UIApplication {
    func openSettings(
        openNotificationSettings: Bool = false,
        completion: @escaping () -> Void
    ) {
        guard let settingsUrl = URL(string: openNotificationSettings ? UIApplication.openNotificationSettingsURLString : UIApplication.openSettingsURLString), canOpenURL(settingsUrl)
        else { return completion() }
        
        open(settingsUrl) { _ in completion() }
    }
}
