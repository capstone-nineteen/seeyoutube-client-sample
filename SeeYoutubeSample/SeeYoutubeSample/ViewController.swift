//
//  ViewController.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/25.
//

import UIKit
import YouTubeiOSPlayerHelper

class ViewController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideo(with: "M7lc1UVf-VE")
    }


}

// MARK: Youtube
extension ViewController {
    private func loadVideo(with id: String) {
        self.playerView.delegate = self
        self.playerView.load(withVideoId: id, playerVars: ["playsinline": "1",
                                                           "controls": "0"])
    }
}

// MARK: YTPlayerViewDelegate
extension ViewController: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        print(playTime)
    }
}
