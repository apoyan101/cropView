//
//  MainViewController.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CropPickerView

final class CropViewController: UIViewController {

    @IBOutlet private weak var cropContainerView: UIView!

    private var cropImageController: CropImageController!
    private let cropPickerView: CropPickerView = {
        let cropPickerView = CropPickerView()
        cropPickerView.translatesAutoresizingMaskIntoConstraints = false
        cropPickerView.backgroundColor = .black
        return cropPickerView
    }()

    required convenience init(cropImageController: CropImageController) {
        self.init()
        self.cropImageController = cropImageController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))

        cropContainerView.addSubviewWithLayoutToBounds(subview: cropPickerView)

        if !UserController.isLoggedIn {
            UserController.login { success in
                print("User logged in: \(success)")
            }
        }
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

// MARK: - InputPickerViewDelegate

extension CropViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 1) {
            cropImageController.uploadData(data: data) { [self] imageData, success in
                if let imageData = imageData {
                    let minx = imageData.objects.first!.vertices.topLeft.x * cropContainerView.bounds.size.width
                    let miny = imageData.objects.first!.vertices.topLeft.y * cropContainerView.bounds.size.height
                    let maxx = imageData.objects.first!.vertices.topRight.x * cropContainerView.bounds.size.width
                    let maxy = imageData.objects.first!.vertices.bottomRight.y * cropContainerView.bounds.size.height

                    let width = maxx - minx
                    let height = maxy - miny
                    cropPickerView.image(image, crop: CGRect(x: minx, y: miny, width: width, height: height), isRealCropRect: true)
                }
            }
        }
        dismiss(animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate -

extension CropViewController: UINavigationControllerDelegate, UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first, let data = try? Data(contentsOf: url), !data.isEmpty  {
            cropImageController.uploadData(data: data) { imageData, success in

            }
        }
        dismiss(animated: true)
    }
}
