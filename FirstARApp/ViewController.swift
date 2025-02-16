//
//  ViewController.swift
//  FirstARApp
//
//  Created by Kyle Wang on 11/30/20.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ViewController: UIViewController, ARSCNViewDelegate {

    let configuration = ARWorldTrackingConfiguration()
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTap(_ gesture: UITapGestureRecognizer) {
        let sceneViewTappedOn = gesture.view as! ARSCNView
        let touchCoordinates = gesture.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates, types:.existingPlaneUsingExtent)

        guard !hitTest.isEmpty, let hitTestResult = hitTest.first else {
            return
        }
        
        let position = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                  hitTestResult.worldTransform.columns.3.y,
                                  hitTestResult.worldTransform.columns.3.z)
        
        print(position)
        addItemToPosition(position)
    }
    
    func addItemToPosition(_ position: SCNVector3) {
        guard let url = Bundle.main.url(forResource: "square",
                                        withExtension: "usdz",
                                        subdirectory: "art.scnassets") else { return }

        let scene = try! SCNScene(url: url, options: [.checkConsistency: true])
        DispatchQueue.main.async {
            if let node = scene.rootNode.childNode(withName: "square", recursively: false) {
                node.position = position
                self.sceneView.scene.rootNode.addChildNode(node)
            }
        }
        

    }
    
    // add cubes at random coordinates
//    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
//        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum — secondNum) + min(firstNum, secondNum)
//    }
    
//    let x = randomNumbers(firstNum: 0.3, secondNum: -0.3)
//    let y = randomNumbers(firstNum: 0.3, secondNum: -0.3)
//    let z = randomNumbers(firstNum: 0.3, secondNum: -0.3)
//

   

    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Enable horizontal plane detection
        configuration.planeDetection = .horizontal

        // show Feature Points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
       
         if let planeAnchor = anchor as? ARPlaneAnchor {
            
             let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
             plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.75)

             let planeNode = SCNNode(geometry: plane)
             planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.x, planeAnchor.center.z)
             planeNode.eulerAngles.x = -.pi / 2
             
             node.addChildNode(planeNode)
         }
     }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
//    @IBAction func didTapButton(){
//        present(SecondViewController(), animated: true)
//    }
}



//
//class SecondViewController: UIViewController, ARSCNViewDelegate {
//
//    @IBOutlet var sceneView: ARSCNView!
//
//    private var viewportSize: CGSize!
//    private var detectRemoteControl: Bool = true
//
//    override var shouldAutorotate: Bool { return false }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        sceneView.delegate = self
//
//        viewportSize = sceneView.frame.size
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        resetTracking()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        sceneView.session.pause()
//    }
//
//    private func resetTracking() {
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = []
//        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
//        detectRemoteControl = true
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard anchor.name == "remoteObjectAnchor" else { return }
//        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.01))
//        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//        node.addChildNode(sphereNode)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
//        guard detectRemoteControl,
//            let capturedImage = sceneView.session.currentFrame?.capturedImage
//            else { return }
//
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: capturedImage, orientation: .leftMirrored, options: [:])
//
//        do {
//            try imageRequestHandler.perform([objectDetectionRequest])
//        } catch {
//            print("Failed to perform image request.")
//        }
//    }
//
//    lazy var objectDetectionRequest: VNCoreMLRequest = {
//        do {
//            let model = try VNCoreMLModel(for: YOLOv3TinyInt8LUT().model)
//            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//                self?.processDetections(for: request, error: error)
//            }
//            return request
//        } catch {
//            fatalError("Failed to load Vision ML model.")
//        }
//    }()
//
//    func processDetections(for request: VNRequest, error: Error?) {
//        guard error == nil else {
//            print("Object detection error: \(error!.localizedDescription)")
//            return
//        }
//
//        guard let results = request.results else { return }
//
//        for observation in results where observation is VNRecognizedObjectObservation {
//            guard let objectObservation = observation as? VNRecognizedObjectObservation,
//                let topLabelObservation = objectObservation.labels.first,
//                topLabelObservation.identifier == "remote",
//                topLabelObservation.confidence > 0.9
//                else { continue }
//
//            guard let currentFrame = sceneView.session.currentFrame else { continue }
//
//            // Get the affine transform to convert between normalized image coordinates and view coordinates
//            let fromCameraImageToViewTransform = currentFrame.displayTransform(for: .portrait, viewportSize: viewportSize)
//            // The observation's bounding box in normalized image coordinates
//            let boundingBox = objectObservation.boundingBox
//            // Transform the latter into normalized view coordinates
//            let viewNormalizedBoundingBox = boundingBox.applying(fromCameraImageToViewTransform)
//            // The affine transform for view coordinates
//            let t = CGAffineTransform(scaleX: viewportSize.width, y: viewportSize.height)
//            // Scale up to view coordinates
//            let viewBoundingBox = viewNormalizedBoundingBox.applying(t)
//
//            let midPoint = CGPoint(x: viewBoundingBox.midX,
//                       y: viewBoundingBox.midY)
//
//            let results = sceneView.hitTest(midPoint, types: .featurePoint)
//            guard let result = results.first else { continue }
//
//            let anchor = ARAnchor(name: "remoteObjectAnchor", transform: result.worldTransform)
//            sceneView.session.add(anchor: anchor)
//
//            detectRemoteControl = false
//        }
//    }
//
//    @IBAction private func didTouchResetButton(_ sender: Any) {
//        resetTracking()
//    }
//}
