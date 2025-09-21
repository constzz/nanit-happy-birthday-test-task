import SwiftUI

struct SnapshotGenerator {
    
    enum Error: Swift.Error, LocalizedError {
        case noView
        case failedToGenerateImage
        
        var localizedDescription: String {
            switch self {
            case .noView:
                return "The view could not be found."
            case .failedToGenerateImage:
                return "Failed to generate image from the view."
            }
        }
    }
    
    static func snapshot<V: View>(_ view: V, completion: @escaping (Result<UIImage, Swift.Error>) -> Void) {
        let controller = UIHostingController(rootView: view)
        controller.view.frame = UIScreen.main.bounds
        DispatchQueue.main.async {
            guard let targetView = controller.view else {
                return completion(.failure(Error.noView))
            }
            let renderer = UIGraphicsImageRenderer(size: targetView.bounds.size)
            let image = renderer.image { ctx in
                targetView.drawHierarchy(in: targetView.bounds, afterScreenUpdates: true)
            }
            if image.size.width > 0 && image.size.height > 0 {
                completion(.success(image))
            } else {
                completion(.failure(Error.failedToGenerateImage))
            }
        }
    }
}
