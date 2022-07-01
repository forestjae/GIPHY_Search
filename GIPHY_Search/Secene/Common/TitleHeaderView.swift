//
//  ListHeaderView.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/07/01.
//

import UIKit

final class TitleHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold).metrics(for: .headline)
        label.textColor = .mainFont
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    func configure(for text: String) {
        self.titleLabel.text = text
    }

    private func configureConstraint() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
