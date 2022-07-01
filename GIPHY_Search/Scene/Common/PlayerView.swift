//
//  PlayerView.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

final class PlayerView: UIView {

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer? {
        guard let layer = self.layer as? AVPlayerLayer else {
            return nil
        }
        layer.videoGravity = .resizeAspectFill
        return layer
    }

    var player: AVPlayer? {
        get {
            return playerLayer?.player
        }

        set {
            playerLayer?.player = newValue
        }
    }
}
