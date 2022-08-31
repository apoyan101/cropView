//
//  CropController.swift
//  test
//
//  Created by Ara Apoyan on 27.08.22.
//

import UIKit
import CropPickerView

protocol CropImageControllerDelegate: AnyObject {
    func reloadImagesCollectionView()
}

final class CropImageController {

    private(set) var croppedImages = [CropResult]()
    private weak var delegate: CropImageControllerDelegate?
    var image: UIImage!
    var imageSize: CGSize!

    init(cropControllerDelegate: CropImageControllerDelegate) {
        delegate = cropControllerDelegate
    }

    public func uploadData(data: Data, completion: @escaping (String) -> Void) {
        let dataName = UUID().uuidString
        UIApplication.appDelegate.apiManager.uploadDataRequestController.uploadData(data: data, dataName: dataName) { [weak self] imageData, message, isSuccess in
            if let imageData = imageData, isSuccess {
                self?.cropImages(cropItems: imageData.objects)
            } else {
                completion(message)
            }
        }
    }

    private func cropImages(cropItems: [CropItem]) {
        croppedImages.removeAll()
        for item in cropItems {
            if let image = image, let imageSize = imageSize {
                let image = image
                let cropMinx = item.vertices.topLeft.x * image.size.width
                let cropMiny = item.vertices.topLeft.y * image.size.height
                let cropMaxx = item.vertices.topRight.x * image.size.width
                let cropMaxy = item.vertices.bottomRight.y * image.size.height
                let cropWidth = cropMaxx - cropMinx
                let cropHeight = cropMaxy - cropMiny
                let realCropFrame = CGRect(x: cropMinx, y: cropMiny, width: cropWidth, height: cropHeight)

                let minx = item.vertices.topLeft.x * imageSize.width
                let miny = item.vertices.topLeft.y * imageSize.height
                let maxx = item.vertices.topRight.x * imageSize.width
                let maxy = item.vertices.bottomRight.y * imageSize.height
                let width = maxx - minx
                let height = maxy - miny
                let cropFrame = CGRect(x: minx, y: miny, width: width, height: height)

                if let croppedImage = image.crop(realCropFrame) {
                    let croppedImageModel = CropResult(image: croppedImage, cropFrame: cropFrame, realCropFrame: realCropFrame, imageSize: imageSize)
                    croppedImages.append(croppedImageModel)
                }
            }
        }
        delegate?.reloadImagesCollectionView()
    }
}
