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

final class CropViewController: BaseViewController {

    @IBOutlet private weak var cropContainerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    // Y Constraint
    @IBOutlet private var cropContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewCenterYConstraint: NSLayoutConstraint!
    // X Constraint
    @IBOutlet private var cropContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewtrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewCenterXConstraint: NSLayoutConstraint!

    private let cropPickerView = CropPickerView()
    private var cropImageController: CropImageController!
    private var selectedIndex = 0

    required convenience init(cropImageController: CropImageController) {
        self.init()
        self.cropImageController = cropImageController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        cropContainerView.addSubviewWithLayoutToBounds(subview: cropPickerView)
        cropImageController.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNibForCell(names: [CroppImageCollectionViewCell.id])
    }

    override func showDataLoadingView() {
        if loaderView == nil {
            loaderView = Loader.showOn(view)
        }
    }

    override func hideDataLoadingView() {
        loaderView?.remove()
        loaderView = nil
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

extension CropViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0.5) {
            showDataLoadingView()
            selectedIndex = 0

            if image.size.width > image.size.height {
                cropContainerViewCenterYConstraint.isActive = false
                cropContainerViewHeightConstraint.isActive = true

                cropContainerViewCenterXConstraint.isActive = false
                cropContainerViewWidthConstraint.isActive = false
                cropContainerViewleadingConstraint.isActive = true
                cropContainerViewtrailingConstraint.isActive = true


                cropPickerView.image(image)
                cropContainerViewHeightConstraint.constant = cropPickerView.imageView.frameForImageInImageViewAspectFit.height
            } else {
                cropContainerViewHeightConstraint.isActive = false
                cropContainerViewCenterYConstraint.isActive = true

                cropContainerViewleadingConstraint.isActive = false
                cropContainerViewtrailingConstraint.isActive = false
                cropContainerViewCenterXConstraint.isActive = true
                cropContainerViewWidthConstraint.isActive = true

                cropPickerView.image(image)
                cropContainerViewWidthConstraint.constant = cropPickerView.imageView.frameForImageInImageViewAspectFit.width
            }
            cropImageController.image = image
            cropImageController.imageSize = cropPickerView.imageView.frameForImageInImageViewAspectFit
            cropImageController.uploadData(data: data)
        }
        dismiss(animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate -

extension CropViewController: UINavigationControllerDelegate, UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first, let data = try? Data(contentsOf: url), !data.isEmpty {
            cropImageController.uploadData(data: data)
        }
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource -

extension CropViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cropImageController.croppedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CroppImageCollectionViewCell.id, for: indexPath) as! CroppImageCollectionViewCell
        let croppedItem = cropImageController.croppedImages[indexPath.row]
        cell.setupCell(image: croppedItem.image, isSelected: indexPath.row == selectedIndex)
        return cell
    }
}

// MARK: - UICollectionViewDelegate -

extension CropViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: [indexPath])
            }
        }
        cropPickerView.image(cropImageController.image, crop: cropImageController.croppedImages[indexPath.row].cropFrame)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // let width = (view.bounds.width - 20) / 3 // TODO: Make responsive
        return CGSize(width: 80, height: 80)
    }
}

// MARK: - CropImageControllerDelegate -

extension CropViewController: CropImageControllerDelegate {
    func reloadImagesCollectionView() {
        collectionView.reloadData()
        if !cropImageController.croppedImages.isEmpty {
            cropPickerView.image(cropImageController.image, crop: cropImageController.croppedImages[selectedIndex].cropFrame)
        }
        hideDataLoadingView()
    }
}
