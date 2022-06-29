//
//  ImageCollectionViewCell.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit
import AVKit
import AVFoundation

class ImageCollectionViewCell: UICollectionViewCell {
    private let playerView: PlayerView = {
        let playerView = PlayerView()
        return playerView
    }()

    private var player: AVPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.clipsToBounds = true
        self.setupHierarchy()
        self.setupConstraint()
        self.contentView.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        self.player = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureContent(_ viewModel: ImageItemViewModel) {
        self.contentView.backgroundColor = .random()
        let videoURL = URL(string: viewModel.image.imageSet.gridMp4URL)!
        CacheManager.fetchVideo(videoURL: videoURL) { asset in
            DispatchQueue.main.async {
                self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                self.playerView.player = self.player
                self.player?.seek(to: CMTime.zero)
                self.player?.play()
                self.player?.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: self.player?.currentItem,
                    queue: .main
                ) { [weak self] _ in
                    self?.player?.seek(to: CMTime.zero)
                    self?.player?.play()
                }
            }
        }
    }

    internal func playVideo() {
        self.player?.play()
    }

    internal func stopVideo() {
        self.player?.pause()
    }

    private func setupHierarchy() {
        self.contentView.addSubview(self.playerView)
    }

    private func setupConstraint() {
        self.playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.playerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.playerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.playerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.playerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
}
