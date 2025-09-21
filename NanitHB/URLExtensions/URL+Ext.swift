//
//  URL+Ext.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//


import Foundation
import MobileCoreServices
import UIKit

extension URL {
    var fileName: String? {
        return lastPathComponent.fileName
    }
    
    var fileNameWithExtension: String? {
        guard let fileName, let fileExtension else { return nil }
        return "\(fileName).\(fileExtension)"
    }
    
    var fileExtension: String? {
        return lastPathComponent.fileExtension?.lowercased()
    }
    
    var image: UIImage? {
        guard let data = try? Data(contentsOf: self),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            Logger.error("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
}
