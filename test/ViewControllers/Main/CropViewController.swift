//
//  MainViewController.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit
import CropPickerView

final class CropViewController: BaseViewController {

    enum ImageType {
        case largerWidth
        case largerHeight
    }

    @IBOutlet private weak var cropContainerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchButton: UIButton!

    // Y Constraint
    @IBOutlet private var cropContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewCenterYConstraint: NSLayoutConstraint!
    // X Constraint
    @IBOutlet private var cropContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewtrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var cropContainerViewCenterXConstraint: NSLayoutConstraint!

    public var imageData: Data!
    private let cropPickerView = CropPickerView()
    private var cropImageController: CropImageController!
    private var selectedIndex = 0
    private var itemSpacing: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Visual Search"
        searchButton.layer.cornerRadius = 4
        showDataLoadingView()
        cropContainerView.addSubviewWithLayoutToBounds(subview: cropPickerView)
        cropImageController = CropImageController(cropControllerDelegate: self)
        cropImageController.image = UIImage(data: imageData)
        cropImageController.uploadData(data: imageData) { [weak self] errorMessage in
            self?.showAlert(message: errorMessage, completion: nil)
        }

        let imageType: ImageType = cropImageController.image.size.width > cropImageController.image.size.height ? .largerWidth : .largerHeight
        setupConstraint(imageType: imageType)
        cropPickerView.image(cropImageController.image)

        switch imageType {
        case .largerWidth:
            cropContainerViewHeightConstraint.constant = cropPickerView.imageView.frameForImageInImageViewAspectFit.height
        case .largerHeight:
            cropContainerViewWidthConstraint.constant = cropPickerView.imageView.frameForImageInImageViewAspectFit.width
        }
        cropImageController.imageSize = cropPickerView.imageView.frameForImageInImageViewAspectFit

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNibForCell(names: [CroppImageCollectionViewCell.id])
    }

    @IBAction private func searchBtnaction() {
        print("Cropped item tapped: \(cropImageController.croppedImages[selectedIndex].realCropFrame)")
    }

    private func setupConstraint(imageType: ImageType) {
        switch imageType {
        case .largerWidth:
            // Y
            cropContainerViewCenterYConstraint.isActive = false
            cropContainerViewHeightConstraint.isActive = true
            // X
            cropContainerViewCenterXConstraint.isActive = false
            cropContainerViewWidthConstraint.isActive = false
            cropContainerViewleadingConstraint.isActive = true
            cropContainerViewtrailingConstraint.isActive = true
        case .largerHeight:
            // Y
            cropContainerViewHeightConstraint.isActive = false
            cropContainerViewCenterYConstraint.isActive = true
            // X
            cropContainerViewleadingConstraint.isActive = false
            cropContainerViewtrailingConstraint.isActive = false
            cropContainerViewCenterXConstraint.isActive = true
            cropContainerViewWidthConstraint.isActive = true
        }
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
        let width = collectionView.bounds.height - itemSpacing
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}

// MARK: - CropImageControllerDelegate -

extension CropViewController: CropImageControllerDelegate {
    func reloadImagesCollectionView() {
        collectionView.reloadData()
        if !cropImageController.croppedImages.isEmpty {
            cropPickerView.image(cropImageController.image, crop: cropImageController.croppedImages[selectedIndex].cropFrame)
        } else {
            showAlert(message: "Select an item manually", completion: nil)
        }
        hideDataLoadingView()
    }
}
