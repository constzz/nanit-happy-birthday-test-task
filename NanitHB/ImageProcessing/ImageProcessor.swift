import Foundation
import SwiftUI

enum ImageProcessor {
    static let backgroundQueue = DispatchQueue(label: "com.nanit.imageProcessing", qos: .userInitiated)
    
    static func convertToImage(_ file: FileCached) async -> Image? {
        await withCheckedContinuation { continuation in
            backgroundQueue.async {
                guard let data = file.data,
                      let uiImage = UIImage(data: data) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: Image(uiImage: uiImage))
            }
        }
    }
}
