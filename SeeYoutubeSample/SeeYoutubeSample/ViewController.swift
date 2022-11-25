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
    @IBOutlet weak var gazePointView: UIImageView!
    private lazy var caliPointView = CalibrationPointView(frame: CGRect(x: 0, y: -40, width: 40, height: 40))
    
    var tracker: GazeTracker? = nil
    private var watchingInfo = WatchingInfo()
    private let faceExpressionPredictor = FaceExpressionPredictor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.loadVideo(with: "M7lc1UVf-VE")
        DispatchQueue.global().async {
            self.startEyeTracking()
        }
    }


}

// MARK: Subviews
extension ViewController {
    private func hideSubview(_ subview: UIView) {
        DispatchQueue.main.async {
            subview.isHidden = true
        }
    }

    private func showSubview(_ subview: UIView) {
        DispatchQueue.main.async {
            subview.isHidden = false
        }
    }
    
    private func configureSubviews() {
        self.hideSubview(self.playerView)
        self.hideSubview(self.gazePointView)
        self.view.addSubview(self.caliPointView)
    }
}

// MARK: WatchingInfo
extension ViewController {
    private func updateWatchingInfo(gazeInfo: GazeInfo) {
        let videoGazeInfo = VideoGazeInfo(gazeInfo: gazeInfo, playerOrigin: self.playerView.frame.origin)
        self.watchingInfo.updateGazeInfo(with: videoGazeInfo)
        
        DispatchQueue.main.async {
            if gazeInfo.trackingState == .SUCCESS {
                self.gazePointView.center = CGPoint(x: gazeInfo.x, y: gazeInfo.y)
                self.showSubview(self.gazePointView)
            } else {
                self.hideSubview(self.gazePointView)
            }
        }
    }
    
    private func updateWatchingInfo(playTime: Float) {
        self.watchingInfo.updatePlayTime(with: playTime)
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
        self.updateWatchingInfo(playTime: playTime)
        print(self.watchingInfo)
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
            self.tracker?.setDelegates(statusDelegate: self,
                                       gazeDelegate: self,
                                       calibrationDelegate: self,
                                       imageDelegate: nil)
            DispatchQueue.global().async {
                self.tracker?.startTracking()
            }
        } else {
            print("ERROR: failed to initialize gaze tracker \(error.description)")
        }
    }
}

// MARK: StatusDelegate
extension ViewController: StatusDelegate {
    func onStarted() {
        print("DEBUG: Tracker starts tracking")
        self.startCalibration()
    }
    
    func onStopped(error: StatusError) {
        print("ERROR: Tracking is stopped - \(error.description)")
    }
}

// MARK: GazeDelegate
extension ViewController: GazeDelegate {
    func onGaze(gazeInfo : GazeInfo) {
        guard let isCalibrating = self.tracker?.isCalibrating(),
              !isCalibrating else { return }
        self.updateWatchingInfo(gazeInfo: gazeInfo)
    }
}

// MARK: Calibration
extension ViewController {
    private func startCalibration() {
        let result = self.tracker?.startCalibration(mode: .ONE_POINT, criteria: .DEFAULT)
        if let isStart = result,
           !isStart {
            print("ERROR: Calibration start failed")
        } else {
            print("DEBUG: Calibration start success")
        }
    }
    
    private func stopCalibration(){
        self.tracker?.stopCalibration()
        self.hideSubview(self.caliPointView)
    }
}

// MARK: CalibrationDelegate
extension ViewController : CalibrationDelegate {
    func onCalibrationProgress(progress: Double) {
        caliPointView.setProgress(progress: progress)
    }
    
    func onCalibrationNextPoint(x: Double, y: Double) {
        DispatchQueue.main.async {
            self.caliPointView.center = CGPoint(x: x, y: y)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let result = self.tracker?.startCollectSamples() {
                print("DEBUG: startCollectSamples : \(result)")
            }
        })
    }
    
    func onCalibrationFinished(calibrationData : [Double]) {
        print("DEBUG: Calibration finished")
        self.tracker?.stopCalibration()
        self.hideSubview(self.caliPointView)
        
        self.showSubview(self.playerView)
        self.playerView.playVideo()
    }
}
