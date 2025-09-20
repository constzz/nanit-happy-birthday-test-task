//
//  String+Ext.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

extension String {
    var fileName: String? {
        if let fileNameComponent = self.components(separatedBy: ".").safelyRetrieve(elementAt: 0) {
            return String(fileNameComponent)
        } else {
            return nil
        }
    }
    
    var fileExtension: String? {
        if let fileNameComponent = self.components(separatedBy: ".").last {
            return String(fileNameComponent)
        } else {
            return nil
        }
    }
    
    var filenameWithExtension: String? {
        guard let fileName, let fileExtension else { return nil }
        return "\(fileName).\(fileExtension)"
    }
}
