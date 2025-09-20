import SwiftUI
import Combine

@MainActor
final class AttachmentsPickerPresenter: ObservableObject {
    private var cancellable: AnyCancellable?
    private var attachmentsController: AttachmentsController?
    
    func present(
        allowedAttachments: [AttachmentsController.Attachment],
        limit: Int = 1,
        onPicked: @escaping ([Image]) -> Void
    ) {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else { return }
            
        attachmentsController = AttachmentsController { [weak rootVC] presentedVC, animated in
            rootVC?.present(presentedVC, animated: animated)
        }
        
        guard let attachmentsController = attachmentsController else { return }
        
        cancellable = attachmentsController.requestAttachment(
            allowedAttachments: allowedAttachments,
            limit: limit
        )
        .sink { [weak self] files in
            let images: [Image] = files?.compactMap { file in
                if let data = try? Data(contentsOf: file.url),
                   let uiImage = UIImage(data: data) {
                    return Image(uiImage: uiImage)
                }
                return nil
            } ?? []
            onPicked(images)
            self?.cancellable = nil
        }
    }
}
