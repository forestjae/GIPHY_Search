//
//  SearchQueryHistoryCollectionViewCell.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/07/01.
//

import UIKit

class SearchQueryHistoryCollectionViewCell: UICollectionViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 20
        stackView.backgroundColor = .darkGray
        return stackView
    }()

    private let imageView: UIImageView = {
        let clockImage = UIImage(systemName: "clock.arrow.circlepath",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold))
        let imageView = UIImageView(image: clockImage)
        imageView.tintColor = .systemYellow
        return imageView
    }()

    private let queryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainFont
        label.font = .systemFont(ofSize: 16, weight: .bold).metrics(for: .headline)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
        self.setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureContent(_ text: String) {
        self.queryLabel.text = text
    }

    private func setupHierarchy() {
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.imageView)
        self.stackView.addArrangedSubview(self.queryLabel)
    }

    private func setupConstraint() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 20),
            self.imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
