//
//  CroppImageCollectionViewCell.swift
//  test
//
//  Created by Ara Apoyan on 29.08.22.
//

import UIKit

final class CroppImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var checkmarkView: UIView!
    @IBOutlet private weak var checkmarkImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        borderView.layer.cornerRadius = 5
        checkmarkView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    public func setupCell(image: UIImage, isSelected: Bool) {
        imageView.image = image
        updateSelectedStated(isSelected: isSelected)
    }

    private func updateSelectedStated(isSelected: Bool) {
        borderView.layer.borderWidth = isSelected ? 2 : 0
        borderView.layer.borderColor = isSelected ? UIColor.purple.cgColor : .none
        checkmarkView.backgroundColor = isSelected ? .purple : .none
        checkmarkImageView.isHidden = !isSelected
    }
}
