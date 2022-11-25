//
//  ViewController.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/25.
//

import UIKit
import YouTubeiOSPlayerHelper
import SeeSo
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    
    var tracker: GazeTracker? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideo(with: "M7lc1UVf-VE")
        DispatchQueue.global().async {
            self.startEyeTracking()
        }
    }


}

// MARK: StatusDelegate
extension ViewController: StatusDelegate {
    func onStarted() {
        print("DEBUG: Tracker starts tracking")
    }
    
    func onStopped(error: StatusError) {
        print("ERROR: Tracking is stopped - \(error.description)")
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

// MARK: Eye-tracking
extension ViewController {
    private func startEyeTracking() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            self.initializeGazeTracker()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { response in
                if response {
                    self.initializeGazeTracker()
                }
            }
        }
    }
    
    private func initializeGazeTracker() {
        if let seesoLicenseKey = Bundle.main.SEESO_LICENSE_KEY {
            GazeTracker.initGazeTracker(license: seesoLicenseKey, delegate: self)
        } else {
            print("ERROR: Cannot find SeeSo license key")
        }
    }
}

// MARK: InitializationDelegate
extension ViewController: InitializationDelegate {
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if (tracker != nil) {
            self.tracker = tracker
            print("DEBUG: initialized gaze tracker")
            self.tracker?.statusDelegate = self
            DispatchQueue.global().async {
                self.tracker?.startTracking()
            }
        } else {
            print("ERROR: failed to initialize gaze tracker \(error.description)")
        }
    }
}
