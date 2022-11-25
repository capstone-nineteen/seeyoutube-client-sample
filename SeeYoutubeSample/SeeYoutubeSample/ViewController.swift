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
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var gazePointView: UIImageView!
    private lazy var caliPointView = CalibrationPointView(frame: CGRect(x: 0, y: -40, width: 40, height: 40))
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
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
        self.hideSubview(self.preview)
        self.hideSubview(self.predictionLabel)
        self.hideSubview(self.playerView)
        self.hideSubview(self.gazePointView)
        self.view.addSubview(self.caliPointView)
    }
    
    private func updatePredictionLabel(with topPrediction: FaceExpressionPredictor.Prediction?) {
        DispatchQueue.main.async {
            if let prediction = topPrediction {
                self.predictionLabel.text = prediction.classification + "\n" + prediction.confidencePercentage + "%"
            } else {
                self.predictionLabel.text = "No Predictions"
            }
        }
    }
    
    private func updateGazePointView(with gazeInfo: GazeInfo) {
        DispatchQueue.main.async {
            if gazeInfo.trackingState == .SUCCESS {
                self.gazePointView.center = CGPoint(x: gazeInfo.x, y: gazeInfo.y)
                self.showSubview(self.gazePointView)
            } else {
                self.hideSubview(self.gazePointView)
            }
        }
    }
}

// MARK: WatchingInfo
extension ViewController {
    private func updateWatchingInfo(gazeInfo: GazeInfo) {
        let videoGazeInfo = VideoGazeInfo(gazeInfo: gazeInfo, playerOrigin: self.playerView.frame.origin)
        self.watchingInfo.updateGazeInfo(with: videoGazeInfo)
        self.updateGazePointView(with: gazeInfo)
    }
    
    private func updateWatchingInfo(playTime: Float) {
        self.watchingInfo.updatePlayTime(with: playTime)
    }
    
    private func updateWatchingInfo(state: EmotionInfo.EmotionPredictionState, predictions: [FaceExpressionPredictor.Prediction] = []) {
        let emotionInfo = EmotionInfo(emotionPredictionState: state, predictionResult: predictions)
        self.watchingInfo.updateEmotionInfo(with: emotionInfo)
        self.updatePredictionLabel(with: predictions.first)
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
                                       imageDelegate: self)
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
        
        self.showSubview(self.preview)
        self.showSubview(self.predictionLabel)
        self.showSubview(self.playerView)
        self.playerView.playVideo()
    }
}

// MARK: ImageDelegate
extension ViewController: ImageDelegate {
    func onImage(timestamp: Double, image: CMSampleBuffer) {
        DispatchQueue.global().async {
            guard let frame = CMSampleBufferGetImageBuffer(image) else {
                print("ERROR: unable to get image from sample buffer")
                return
            }
            self.detectFace(in: frame)
        }
    }
}

// MARK: Face Expression Prediction
extension ViewController {
    /// 카메라 프레임으로부터 얼굴을 탐지한다.
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            if let results = request.results as? [VNFaceObservation] {
                self.handleFaceDetectionResults(results, image: image)
            }
        })
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
    
    /// 얼굴 탐지 결과를 바탕으로 얼굴 부분만 크롭한다.
    func handleFaceDetectionResults(_ observedFaces: [VNFaceObservation], image: CVPixelBuffer) {
        guard let observedFace = observedFaces.first else {
            self.updateWatchingInfo(state: .faceMissing)
            return
        }

        let ciImage = CIImage(cvPixelBuffer: image).transformed(by: CGAffineTransform(rotationAngle: .pi))
        let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent)

        guard let cgImage = cgImage?.croppingDetectionBondingBox(to: observedFace.boundingBox) else {
            self.updateWatchingInfo(state: .failedToCropFace)
            return
        }
        
        DispatchQueue.main.async {
            self.preview.image = UIImage(cgImage: cgImage)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyFaceExpression(cgImage)
        }
    }
    
    /// 표정 분석을 수행한다.
    private func classifyFaceExpression(_ image: CGImage) {
        do {
            try self.faceExpressionPredictor.makePredictions(for: image) { [weak self] predictions in
                if let predictions = predictions {
                    self?.updateWatchingInfo(state: .success, predictions: predictions)
                } else {
                    self?.updateWatchingInfo(state: .noPredictions)
                }
            }
        } catch {
            print("ERROR: Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
}
