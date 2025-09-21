import SwiftUI
import Combine

@MainActor
final class AttachmentsPickerPresenter: ObservableObject {
    private var cancellable: AnyCancellable?
    private var attachmentsController: AttachmentsController?
    
    func present(
        allowedAttachments: [AttachmentsController.Attachment],
        limit: Int,
        onPicked: @escaping ([FileCached]) -> Void
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
            self?.cancellable = nil
            guard let files, files.isNotEmpty else { return }
            onPicked(files)
        }
    }
}
