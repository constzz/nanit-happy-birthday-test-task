//
//  AttachmentsController.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import Foundation
import PhotosUI
import Combine

final class AttachmentsController: NSObject, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    typealias PresentControllerHandler = (UIViewController, _ animated: Bool) -> Void
    
    private let newFileAttachedSubject = PassthroughSubject<[FileCached]?, Never>()
    private let presentController: PresentControllerHandler
    
    enum Attachment {
        case library(allowedMediaTypes: [MediaType])
        case file
        case camera(allowedMediaTypes: [MediaType], camera: Camera, allowsEditing: Bool)
        
        enum Camera {
            case rear
            case front
        }
        
        enum MediaType {
            case photo
            case video
        }
    }
    
    init(presentController: @escaping PresentControllerHandler) {
        self.presentController = presentController
    }
    
    func requestAttachment(allowedAttachments: [Attachment], limit: Int) -> AnyPublisher<[FileCached]?, Never> {
        let actionSheet = UIAlertController(title: NSLocalizedString("Attachments", comment: "Attachments alert title"), message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel))
        
        allowedAttachments.forEach { attachment in
            switch attachment {
            case .file:
                actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Documents", comment: "Documents action"), style: .default) { [weak self] _ in
                    self?.openFilesPicker()
                })
            case .library(let allowedMediaTypes):
                let libraryAction = UIAlertAction(
                    title: NSLocalizedString("Library", comment: "Library action"),
                    style: .default, handler: { [weak self] _ in
                        self?.openPhotoLibraryPicker(itemsLimit: limit, allowedMediaTypes: allowedMediaTypes)
                    })
                actionSheet.addAction(libraryAction)
            case .camera(let allowedMediaTypes, let camera, let allowsEditing):
                let cameraIsAllowed = DeviceAccess.VideoRecording.isGranted(shouldAskIfNotDetermined: true)
                let cameraTitle = cameraIsAllowed ? NSLocalizedString("Camera", comment: "Camera action") : NSLocalizedString("Give Access to Camera", comment: "Camera access action")
                let cameraAction = UIAlertAction(
                    title: cameraTitle,
                    style: .default, handler: { [weak self] _ in
                        if cameraIsAllowed {
                            self?.openCameraImagePicker(allowedMediaTypes: allowedMediaTypes, cameraDevice: camera.cameraDevice, allowsEditing: allowsEditing)
                        } else {
                            UIApplication.shared.openSettings {}
                        }
                    })
                actionSheet.addAction(cameraAction)
            }
        }
        presentController(actionSheet, true)
        
        return newFileAttachedSubject.first().eraseToAnyPublisher()
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let group = DispatchGroup()
        var filesCached = [FileCached]()
        for pickerResult in results {
            group.enter()
            pickerResult.loadAsFile(possibleFileTypes: [.photo, .video]) { result in
                if let fileURL = try? result.get() {
                    if let file = try? FileCached.make(localURL: fileURL) {
                        filesCached.append(file)
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            picker.dismiss(animated: true, completion: nil)
            self?.newFileAttachedSubject.send(filesCached)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        let localPath = NSTemporaryDirectory().appending(UUID().uuidString).appending(".jpeg")
        
        func saveLocallyImage(_ image: UIImage) -> URL? {
            guard let data = image.jpegData(compressionQuality: 1.0) as? NSData else { return nil }
            data.write(toFile: localPath, atomically: true)
            return URL.init(filePath: localPath)
        }
        
        let url: URL? = {
            if let image = info[.editedImage] as? UIImage {
                return saveLocallyImage(image)
            } else if let image = info[.originalImage] as? UIImage {
                return saveLocallyImage(image)
            } else if let videoURL = info[.mediaURL] as? URL {
                return videoURL
            } else {
                return nil
            }
        }()
        
        guard let url = url else { return Logger.error("Not enough info to attach media with info: \(info).") }
        if let file = try? FileCached.make(localURL: url) {
            newFileAttachedSubject.send([file])
        }
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let files = urls
            .filter({ $0.startAccessingSecurityScopedResource() })
            .compactMap({ try? FileCached.make(localURL: $0) })
        newFileAttachedSubject.send(files)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

private extension AttachmentsController {
    static let allDocumentTypes = [
        "com.apple.iwork.pages.pages",
        "com.apple.iwork.numbers.numbers",
        "com.apple.iwork.keynote.key",
        "public.image",
        "com.apple.application",
        "public.item",
        "public.content",
        "public.audiovisual-content",
        "public.movie",
        "public.audiovisual-content",
        "public.video",
        "public.audio",
        "public.text",
        "public.data",
        "public.zip-archive",
        "com.pkware.zip-archive",
        "public.composite-content"
    ]
    
    func openFilesPicker() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: AttachmentsController.allDocumentTypes, in: .open)
        documentPickerController.delegate = self
        presentController(documentPickerController, true)
    }
    
    func openPhotoLibraryPicker(itemsLimit: Int, allowedMediaTypes: [AttachmentsController.Attachment.MediaType]) {
        let photoLibrary = PHPhotoLibrary.shared()
        
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.selectionLimit = itemsLimit
        configuration.filter = .any(of: allowedMediaTypes.map { $0.filter })
        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        presentController(photoPicker, true)
    }
    
    func openCameraImagePicker(
        allowedMediaTypes: [AttachmentsController.Attachment.MediaType],
        cameraDevice: UIImagePickerController.CameraDevice,
        allowsEditing: Bool
    ) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.mediaTypes = allowedMediaTypes.map { $0.utType.identifier }
        vc.cameraDevice = cameraDevice
        vc.allowsEditing = allowsEditing
        vc.delegate = self
        vc.cameraFlashMode = .auto
        presentController(vc, true)
    }
}

private extension AttachmentsController.Attachment.MediaType {
    var filter: PHPickerFilter {
        switch self {
        case .photo: return .images
        case .video: return .videos
        }
    }
    
    var utType: UTType {
        switch self {
        case .photo:
            return UTType.image
        case .video:
            return UTType.movie
        }
    }
}

private extension AttachmentsController.Attachment.Camera {
    var cameraDevice: UIImagePickerController.CameraDevice {
        switch self {
        case .rear:
            return .rear
        case .front:
            return .front
        }
    }
}
