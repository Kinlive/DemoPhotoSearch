//
//  PhotoResultCell.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/26.
//

import UIKit

class PhotosResultCell: UICollectionViewCell {

    // MARK: - Subviews
    lazy var photoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()

    lazy var titleBaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        makeUIsConstraints()
    }

    func configure(photo: Photo) {

        let imageUrl = "https://farm\(photo.farm).staticflickr.com/\(photo.server ?? "")/\(photo.id)_\(photo.secret ?? "").jpg"

        titleLabel.text = photo.title
        photoImageView.downloaded(from: imageUrl)

    }

    // MARK: - Make UIs
    private func addSubviews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleBaseView)
        contentView.addSubview(titleLabel)
    }

    private func makeUIsConstraints() {

        // Photo
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        // Title base view
        titleBaseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleBaseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleBaseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        titleBaseView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // title
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleBaseView.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: titleBaseView.bottomAnchor, constant: 5).isActive = true

    }
}

