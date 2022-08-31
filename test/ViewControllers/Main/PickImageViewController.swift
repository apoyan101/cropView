//
//  PickImageViewController.swift
//  test
//
//  Created by Ara Apoyan on 31.08.22.
//

import UIKit
import AVFoundation
import MobileCoreServices

final class PickImageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Select image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    }

    @objc private func addPhoto() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { _ in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { [self] in
                    if granted {
                        let picker = UIImagePickerController()
                        picker.sourceType = .camera
                        picker.showsCameraControls = true
                        picker.allowsEditing = true
                        picker.delegate = self
                        present(picker, animated: true, completion: nil)
                    } else {
                        presentCameraSettings()
                    }
                }
            }
        }))
        sheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [self] _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            present(picker, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Files", style: .default, handler: { [self] _ in
            var documentPicker: UIDocumentPickerViewController!
            if #available(iOS 14, *) {
                let supportedTypes = [UTType.image]
                documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
            } else {
                let supportedTypes = [kUTTypeImage as String]
                documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
            }
            documentPicker.delegate = self
            present(documentPicker, animated: true)

        }))
        sheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        present(sheet, animated: true)
    }

  

    private func presentCameraSettings() {
        let alertController = UIAlertController(title: "Camera is unavailable", message: "To upload camera images turn on Camera access in the settings.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Not now", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in

                })
            }
        })
        present(alertController, animated: true)
    }
}

// MARK: - InputPickerViewDelegate -

extension PickImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0.5) {
            showDataLoadingView()
            dismiss(animated: true)
            let cropViewController = CropViewController()
            cropViewController.imageData = data
            navigationController?.pushViewController(cropViewController, animated: true, completion: { [self] in
                hideDataLoadingView()
            })
        }
    }
}

// MARK: - UIDocumentPickerDelegate -

extension PickImageViewController: UINavigationControllerDelegate, UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first, let data = try? Data(contentsOf: url), !data.isEmpty {
            showDataLoadingView()
            dismiss(animated: true)
            let cropViewController = CropViewController()
            cropViewController.imageData = data
            navigationController?.pushViewController(cropViewController, animated: true, completion: { [self] in
                hideDataLoadingView()
            })
        }
    }
}



