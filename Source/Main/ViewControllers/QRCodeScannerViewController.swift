//
//  QRCodeScannerViewController.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 23/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAnalytics

protocol QRCodeDelegate {
  func updateQRCode(withAddress address: String)
}

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  @IBOutlet var messageLabel:UILabel!
  @IBOutlet var topbar: UIView!
  
  var captureSession:AVCaptureSession?
  var videoPreviewLayer:AVCaptureVideoPreviewLayer?
  var qrCodeFrameView:UIView?
  
  var delegate: QRCodeDelegate?
  
//  let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
//                            AVMetadataObjectTypeCode39Code,
//                            AVMetadataObjectTypeCode39Mod43Code,
//                            AVMetadataObjectTypeCode93Code,
//                            AVMetadataObjectTypeCode128Code,
//                            AVMetadataObjectTypeEAN8Code,
//                            AVMetadataObjectTypeEAN13Code,
//                            AVMetadataObjectTypeAztecCode,
//                            AVMetadataObjectTypePDF417Code,
//                            AVMetadataObjectTypeQRCode]
  
  let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    do {
      // Get an instance of the AVCaptureDeviceInput class using the previous device object.
      let input = try AVCaptureDeviceInput(device: captureDevice!)
      
      // Initialize the captureSession object.
      captureSession = AVCaptureSession()
      
      // Set the input device on the capture session.
      captureSession?.addInput(input)
      
      // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession?.addOutput(captureMetadataOutput)
      
      // Set delegate and use the default dispatch queue to execute the call back
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
      
      // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      videoPreviewLayer?.frame = view.layer.bounds
      view.layer.addSublayer(videoPreviewLayer!)
      
      // Start video capture.
      captureSession?.startRunning()
      
      // Move the message label and top bar to the front
      view.bringSubviewToFront(messageLabel)
      view.bringSubviewToFront(topbar)
      
      // Initialize QR Code Frame to highlight the QR code
      qrCodeFrameView = UIView()
      
      if let qrCodeFrameView = qrCodeFrameView {
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView)
        view.bringSubviewToFront(qrCodeFrameView)
      }
      
    } catch {
      // If any error occurs, simply print it out and don't continue any more.
      print(error)
      return
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Analytics.setScreenName("QR Code Scanner", screenClass: nil)
  }
  
  @IBAction func closeAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if (captureSession?.isRunning == false) {
      captureSession?.startRunning()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if (captureSession?.isRunning == true) {
      captureSession?.stopRunning()
    }
  }
  
  
  // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    captureSession?.stopRunning()
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if metadataObjects == nil || metadataObjects.count == 0 {
      qrCodeFrameView?.frame = CGRect.zero
      messageLabel.text = "No QR/barcode is detected"
      return
    }
    
    // Get the metadata object.
    let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    
    if supportedCodeTypes.contains(metadataObj.type) {
      // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
      let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
      qrCodeFrameView?.frame = barCodeObject!.bounds
      
      if metadataObj.stringValue != nil {
        messageLabel.text = metadataObj.stringValue
        delegate?.updateQRCode(withAddress: metadataObj.stringValue!)
        dismiss(animated: true, completion: nil)
      }
    }
  }
  
}
