//
//  DetailViewController.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit
import AVKit
import AVFoundation

final class DetailViewController: UIViewController {

    // MARK: - Variable(s)

    var viewModel: DetailViewModel?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let playerView: PlayerView = {
        let playerView = PlayerView()
        playerView.layer.cornerRadius = 5
        playerView.clipsToBounds = true
        return playerView
    }()

    private let userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        let skeletonImage = UIImage(systemName: "globe.americas.fill")
        imageView.image = skeletonImage
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .darkGray
        return imageView
    }()

    private let userNameSetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = .init(top: 5, leading: 2, bottom: 5, trailing: 2)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let userDisplayedNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainFont
        label.font = .systemFont(ofSize: 16, weight: .heavy).metrics(for: .headline)
        return label
    }()

    private let userNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondFont
        label.font = .systemFont(ofSize: 12, weight: .bold).metrics(for: .caption1)
        return label
    }()

    private let verifiedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "verified"))
        imageView.isHidden = true
        return imageView
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.setPreferredSymbolConfiguration(.init(pointSize: 28, weight: .bold), forImageIn: .normal)
        button.tintColor = .mainTint
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 28, weight: .bold), forImageIn: .normal)
        button.tintColor = .mainTint
        return button
    }()

    // MARK: - Override(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
        self.setupSubviews()
        self.setupHierarchy()
        self.setupConstraint()
        self.binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.loadUserImage()
        self.viewModel?.favoriteStatus()
    }

    // MARK: - Private Method(s)

    private func setupController() {
        self.view.addSubview(self.scrollView)
        self.view.backgroundColor = .black
        self.navigationItem.title = self.viewModel?.title
    }

    private func setupSubviews() {
        self.setupNameSetStackView()
        self.setupPlayerView()
        self.setupIsFavoriteButton()
    }

    private func setupPlayerView() {
        guard let urlString = self.viewModel?.animatedImageURL,
              let videoURL = URL(string: urlString)
        else {
            return
        }

        CacheManager.fetchVideo(videoURL: videoURL) { asset in
            let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
            DispatchQueue.main.async { [weak self] in
                self?.playerView.player = player
                player.play()
                player.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main
                ) { _ in
                    player.seek(to: CMTime.zero)
                    player.play()
                }
            }
        }
    }

    private func setupNameSetStackView() {
        if let userName = self.viewModel?.userName {
            self.userDisplayedNameLabel.text = self.viewModel?.userDisplayedName ?? userName
            self.userNameLabel.text = "@" + userName
        } else if let source = self.viewModel?.source {
            self.userDisplayedNameLabel.text = "Source"
            self.userDisplayedNameLabel.textColor = .secondFont
            self.userDisplayedNameLabel.font = .systemFont(ofSize: 12, weight: .bold)
                .metrics(for: .callout)
            self.userNameLabel.text = source
            self.userNameLabel.textColor = .mainFont
            self.userNameLabel.font = .systemFont(ofSize: 16, weight: .heavy)
                .metrics(for: .headline)
        } else {
            self.userImageView.isHidden = true
            self.userNameLabel.isHidden = true
            self.userDisplayedNameLabel.isHidden = true
        }

        if self.viewModel?.isVerified == true {
            self.verifiedImageView.isHidden = false
        }
    }

    private func setupIsFavoriteButton() {
        self.favoriteButton.addTarget(
            self,
            action: #selector(isFavoriteButtonDidTap),
            for: .touchUpInside
        )
    }

    @objc
    private func isFavoriteButtonDidTap() {
        if self.favoriteButton.isSelected {
            self.viewModel?.setUnfavorite { result in
                DispatchQueue.main.async {
                    self.favoriteButton.isSelected = result
                }
            }
        } else {
            self.viewModel?.setFavorite { result in
                DispatchQueue.main.async {
                    self.favoriteButton.isSelected = result
                }
            }
        }
    }

    private func setupHierarchy() {
        self.scrollView.addSubview(self.mainStackView)
        self.mainStackView.addArrangedSubview(self.playerView)
        self.mainStackView.addArrangedSubview(self.userStackView)
        self.userStackView.addArrangedSubview(self.userImageView)
        self.userStackView.addArrangedSubview(self.userNameSetStackView)
        self.userStackView.addArrangedSubview(self.favoriteButton)
        self.userStackView.addArrangedSubview(self.shareButton)
        self.userNameSetStackView.addArrangedSubview(self.userDisplayedNameLabel)
        self.userNameSetStackView.addArrangedSubview(self.userNameStackView)
        self.userNameStackView.addArrangedSubview(self.userNameLabel)
        self.userNameStackView.addArrangedSubview(self.verifiedImageView)
    }

    private func setupConstraint() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            self.scrollView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            ),
            self.scrollView.leadingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
            ),
            self.scrollView.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
            )
        ])

        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainStackView.topAnchor.constraint(
                equalTo: self.scrollView.contentLayoutGuide.topAnchor
            ),
            self.mainStackView.bottomAnchor.constraint(
                equalTo: self.scrollView.contentLayoutGuide.bottomAnchor
            ),
            self.mainStackView.leadingAnchor.constraint(
                equalTo: self.scrollView.frameLayoutGuide.leadingAnchor
            ),
            self.mainStackView.trailingAnchor.constraint(
                equalTo: self.scrollView.frameLayoutGuide.trailingAnchor
            )
        ])

        self.playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.heightAnchor.constraint(equalToConstant: 200)
        ])

        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userImageView.widthAnchor.constraint(equalToConstant: 40),
            self.userImageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.verifiedImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.verifiedImageView.widthAnchor.constraint(equalToConstant: 14),
            self.verifiedImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func binding() {
        self.viewModel?.userImage = { [weak self] data in
            DispatchQueue.main.async {
                self?.userImageView.image = UIImage(data: data)
            }
        }
        self.viewModel?.isFavorite = { [weak self] bool in
            DispatchQueue.main.async {
                self?.favoriteButton.isSelected = bool
            }
        }
    }
}
