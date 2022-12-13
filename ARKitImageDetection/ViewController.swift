/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
 
 Adopted from Apple Documentation Example on ARKit
 
 Additional code sourced and adapted from:
    - Google's OAuth Documentation for Swift
    - Apple Documentation on CoreBluetooth: https://developer.apple.com/documentation/corebluetooth
    - Igor Kravtsov (distance between two anchors in ARKit) https://virtualrealitypop.com/ios-11-tutorial-how-to-measure-objects-with-arkit-743d2ec78afc
    - Stack Overflow post about sending emails from Swift https://stackoverflow.com/questions/38375385/sending-an-email-from-your-app-with-an-image-attached-in-swift
    - Stack Overflow post about webhooks in Swift https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method

*/

import ARKit
import SceneKit
import UIKit

import MessageUI
//import CoreMotion

import CoreBluetooth

import GoogleSignIn
import GoogleAPIClientForREST_Drive

class ViewController: UIViewController, ARSCNViewDelegate, CBPeripheralDelegate, CBCentralManagerDelegate, MFMailComposeViewControllerDelegate {
//class ViewController: UIViewController, ARSCNViewDelegate {
    // Properties for Bluetooth
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
//
//    // acceleration
//    var motionManager: CMMotionManager!
    
    // tap for distance
    var nodes: [SphereNode] = []
    var orientation: SCNVector3!
    var location: SCNVector3!
    
    // for timer:
    var seconds: Int!
    var or: simd_float4!
    var pos: simd_float4!
    
    // Google Drive
    @IBOutlet weak var signInButton: UIButton!
    let service = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    var uploadFolderID: String?
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    var timer = Timer()
    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
//
//        motionManager = CMMotionManager()
//        motionManager.startDeviceMotionUpdates()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapRecognizer)
        
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().scopes =
//            [kGTLRAuthScopeDrive]
        
//        GIDSignIn.sharedInstance.signInSilently()
//        let button = GIDSignInButton(frame: CGRect())
//        googleSignIn { signInStatus in
//            if signInStatus == true {
//                self.signInButton.setTitle("Sign out", for: .normal)
//                print("Signed in!")
//            } else {
//                self.signInButton.setTitle("Sign in", for: .normal)
//                print("Issues with signing in...")
//            }
//        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateCounting()
            })
//        scheduledTimerWithTimeInterval()
        
    }

//    print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))
//    calendar.timeZone = TimeZone(identifier: "UTC")!
    
    // *** Get Individual components from date ***
//    let hour = calendar.component(.hour, from: date)
//    let minutes = calendar.component(.minute, from: date)
//    let seconds = calendar.component(.second, from: date)
//    print("\(hour):\(minutes):\(seconds)")
    
//    var count = seconds
    var lastInterval = 30
//    var lastInterval: TimeInterval = 0
//    func update(_ currentTime: TimeInterval) {
//        if lastInterval == nil {
//            lastInterval = currentTime
//        }
//
//        var delta: CFTimeInterval = currentTime - lastInterval
//
//        if delta >= 1000 {
//            updateCounting()
//        }
//
//        lastInterval = currentTime
//    }
    
//    func scheduledTimerWithTimeInterval(){
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//            self.updateCounting()
//                        })
//    }
    
//    func updateCounting(seconds: Int, orientation: simd_float4, location: simd_float4){
    func updateCounting(){
        print("counting...")
//        var seconds = Calendar.current.component(.second, from: date)
        print(seconds)
        let val = (seconds ?? 0) + 1
        let value1 = "\(val)"
        print("ORIENTATION: ", or)
        print("LOCATION: ", pos)
        if (or != nil && pos != nil) {
            let value2 = "\(pos.x),\(pos.y),\(pos.z),\(or.x),\(or.y),\(or.z)"
//            let value3 = "\(pos.x),\(pos.y),\(pos.z)"
//            let value2 = "\(orientation.x),\(orientation.y),\(orientation.z)"
//            let value3 = "\(location.x),\(location.y),\(location.z)"
            print("value1: ", value1)
            print("orientation and location: ", value2)
//            print("location: ", value3)
//            count += 1
//            let url = URL(string: "")
            let url = URL(string: "https://maker.ifttt.com/trigger/document_test/with/key/b0P9Uu_Dc-4YuGZ8AA_Ddo?value1=\(value1)&value2=\(value2)")
            
            guard let requestUrl = url else { print("no url found"); return;}
            // Prepare URL Request Object
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            
            let boundary = String(format: "----iOSURLSessionBoundary.%08x%08x", arc4random(), arc4random())
            let body = Data()
            
            print("**************************************** body: ", body)
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // set HTTP request body
            request.httpBody = body
            
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
            }
            task.resume()
        }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed to avoid interuppting the AR experience.
		UIApplication.shared.isIdleTimerDisabled = true

        // Start the AR experience
        resetTracking()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

        session.pause()
	}

    // MARK: - Session management (Image detection setup)
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true

    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
	func resetTracking() {
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
	}

    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//            self.updateCounting()
//            })
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        updateQueue.async { [self] in
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.005
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
            
            guard let pointOfView = self.sceneView.pointOfView else { return }
            let transform = pointOfView.transform
            orientation = SCNVector3(-transform.m31, -transform.m32, transform.m33)
            location = SCNVector3(transform.m41, transform.m42, transform.m43)
            print("*****************FOUND APRIL TAG******************************")
            print("orientation: ", orientation)
            print("location: ", location)
            //            let distance = 3 * 2 * 26 / 26
            //            print("DISTANCE FROM PHONE ESTIMATED: ", distance, "inches")
            
            //            let imageName = referenceImage.name ?? ""
            //            print("++++++++++++++++++++++++++++++++++FOUND+++++++++++++++++++++++++++++++++++++++++++")
            //            self.statusViewController.cancelAllScheduledMessages()
            //            self.statusViewController.showMessage("Detected image “\(imageName)”")
            
            // take screenshot
            let screenshot = sceneView.snapshot()
            
            UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            guard let screenshotData = screenshot.jpegData(compressionQuality: 0.25) else {
                print("oops - no screenshot taken")
                fatalError()
            }
            
//            guard let screenshotData = UIImageJPEGRepresentation(screenshot, 0.25) else {
//                print("oops - no screenshot taken")
//                fatalError()
//            }
            
//            if MFMailComposeViewController.canSendMail() {
//                let mail = MFMailComposeViewController()
//
//                mail.setToRecipients(["alyssachew@g.ucla.edu"])
//                mail.setSubject("IMAGE attached")
//                mail.setMessageBody("Here's screenshot!", isHTML: true)
//                mail.addAttachmentData(screenshotData, mimeType: "image/jpeg", fileName: "bedroom_light.jpeg")
//
//                mail.mailComposeDelegate = self
//
//                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!ATTEMPTING TO SEND IMAGE AS JPEG TO EMAIL ADDRESS")
////                let ismain = Thread.isMainThread
////                print("Are we on main thread already? \(ismain)")
////                DispatchQueue.main.async{
////                    self.present(mail, animated: true)
////                }
//            }
            
            let filename = referenceImage.name ?? "" + ".jpg"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print(paths)
            let docDirectoryPath = paths[0]
            print(docDirectoryPath)
            let filePath = docDirectoryPath.appendingPathComponent(filename)
            print(filePath)
            let success = FileManager.default.createFile(atPath: filePath.path, contents: screenshotData, attributes: nil)
//            showAlert(title: success ? "Success" : "Failed", message: filePath.path)
            print(filePath.path)
            
            // Prepare URL
            let imageName = referenceImage.name ?? ""
            print("*************************************************************image name: ", imageName)
            var url = URL(string: "")
            if (imageName == "bedroom_light") {
                print("*************************************************************BEDROOM LIGHT")
//                let msg = String(format: "Your %@ is %@ years old", arguments: args)
                
                let value1 = "\(location.x),\(location.y),\(location.z),\(orientation.x),\(orientation.y),\(orientation.z)"
                let value2 = "\(location.x),\(location.y),\(location.z)"
                print("orientation.x", orientation.x)
                print("value1: ", value1)
                print("value2: ", value2)
                url = URL(string: "https://maker.ifttt.com/trigger/bedroom_switch/with/key/dhHi1S8AjfU52cs3Yj8a4M?value1=\(value1)&value2=\(value2)")
                print(url)
            }
            else if (imageName == "kitchen_light") {
                print("*************************************************************KITCHEN LIGHT")
                url = URL(string: "https://maker.ifttt.com/trigger/kitchen_switch/with/key/dhHi1S8AjfU52cs3Yj8a4M")
            }
            else {
                url = URL(string: "")
            }
//            let url = URL(string: "https://www.googleapis.com/upload/drive/v3/files?uploadType=media")
//            print("*************************************************************url: ", url)
            guard let requestUrl = url else { print("no url found"); return;}
            
            // Prepare URL Request Object
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
             
            // to send screenshot
            let uuid = UUID().uuidString
            let CRLF = "\r\n"
            let fileName = uuid + ".jpg"
            let formName = "file"
            let type = "image/jpeg"     // file type
            let boundary = String(format: "----iOSURLSessionBoundary.%08x%08x", arc4random(), arc4random())
            var body = Data()
            
            let json: [String: Any] = ["value1": "test", "value2": "hello", "value3": "hi", "Value1": "Test", "Value2": "Hello", "Value3": "Hi"]
//            let json = "{\"value1\": \"test\", \"value2\": \"hello\", \"value3\": \"hi\"}"
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            // file data
//            body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(formName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//            body.append(("Content-Type: \(type)" + CRLF + CRLF).data(using: .utf8)!)
//            body.append(screenshotData as Data)
//            body.append(CRLF.data(using: .utf8)!)

            // footer
//            body.append(("--\(boundary)--" + CRLF).data(using: .utf8)!)
            
//            let parameters: [String: Any] = [
//                "id": imageName
//            ]
            print("**************************************** jsonData: ", jsonData)
            print("**************************************** body: ", body)
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // set HTTP request body with screenshotData
            request.httpBody = jsonData
//            request.httpBody = parameters
                        
            // HTTP Request Parameters which will be sent in HTTP Request Body
//            let postString = referenceImage.name ?? "";

            // Set HTTP Request Body
//            request.httpBody = postString.data(using: String.Encoding.utf8);

            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    // Check for Error
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
             
                    // Convert HTTP Response Data to a String
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string:\n \(dataString)")
                    }
            }
            task.resume()
            
            print("**************************************** intrinsics??? ", session.currentFrame?.camera.intrinsics)
        }

        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            print("++++++++++++++++++++++++++++++++++FOUND+++++++++++++++++++++++++++++++++++++++++++")
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {
            print("Error Saving ARKit Scene \(error)")
        } else {
            print("ARKit Scene Successfully Saved")
        }
    }
    
    private func showAlert(title: String, message: String) {
           let alertController =
               UIAlertController(title: title,
                                 message: message,
                                 preferredStyle: .alert)
           
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(okAction)
           
           self.present(alertController, animated: true, completion: nil)
       }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        //2
        let tapLocation = sender.location(in: sceneView)
        //3
        let hitTestResults = sceneView.hitTest(tapLocation, types: .featurePoint)
        var distance = 0.0;
        if let result = hitTestResults.first {
            //4
            let transform = result.worldTransform
            let position = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            //5
            let sphere = SphereNode(position: position)
            //6
            sceneView.scene.rootNode.addChildNode(sphere)
            let camera = session.currentFrame?.camera.transform
            nodes.append(sphere)
            if camera?.columns.3 != nil {
                //7
//                let distance = lastNode!.position.distance(to: sphere.position)
                distance = Double(abs(sqrt(
                    pow(camera!.columns.3.x - sphere.position.x, 2) +
                    pow(camera!.columns.3.y - sphere.position.y, 2) +
                    pow(camera!.columns.3.z - sphere.position.z, 2)
                )))
                print("camera position: “\(camera!.columns.3)”")
                print("sphere position: “\(sphere.position)”")
                self.statusViewController.showMessage("Distance from image (m): “\(distance)”")
                print("DISTANCE USING HANDLETAP FUNCTION: ", distance)
            }
        }
        
        let screenshot = sceneView.snapshot()
        guard let screenshotData = screenshot.jpegData(compressionQuality: 0.25) else {
            print("oops - no screenshot taken")
            fatalError()
        }
                
        if MFMailComposeViewController.canSendMail() {
//            let imageName = referenceImage.name ?? ""
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["alyssachew@g.ucla.edu", "projectece202a@gmail.com", "projectece202a@outlook.com"])
            mail.setSubject("Image attached")
            mail.setMessageBody("Here's april tag! Distance from image (m): “\(distance)” Orientation: “\(orientation)” Location: “\(location)”", isHTML: true)
            mail.mailComposeDelegate = self
            mail.addAttachmentData(screenshotData, mimeType: "image/jpeg" , fileName: "“”.jpeg")
            let ismain = Thread.isMainThread
            print("Are we on main thread already? \(ismain)")
            DispatchQueue.main.async {
                self.present(mail, animated: true)
            }

        }
        else {
            print("Email cannot be sent")
        }
    }

    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.75, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }
    
    // Bluetooth: If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(
            withServices: [ParticlePeripheral.particleLEDServiceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }

    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        // We've found it so stop scan
        self.centralManager.stopScan()

        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self

        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)

    }

    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Particle Board")
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID])
        }
    }

    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    print("WHOA BLUETOOTH service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics(
                        [ParticlePeripheral.redLEDCharacteristicUUID,
                         ParticlePeripheral.greenLEDCharacteristicUUID,
                         ParticlePeripheral.blueLEDCharacteristicUUID],
                         for: service)
                    return
                }
            }
        }
    }

    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("inside peripheral")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.redLEDCharacteristicUUID {
                    print("Red LED characteristic found")
                } else if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID {
                    print("Green LED characteristic found")
                } else if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID {
                    print("Blue LED characteristic found");
                }
            }
        }
    }
    
    // google drive folder
    func getFolderID(
        name: String,
        service: GTLRDriveService,
        user: GIDGoogleUser,
        completion: @escaping (String?) -> Void) {
        
        let query = GTLRDriveQuery_FilesList.query()

        // Comma-separated list of areas the search applies to. E.g., appDataFolder, photos, drive.
        query.spaces = "drive"
        
        // Comma-separated list of access levels to search in. Some possible values are "user,allTeamDrives" or "user"
        query.corpora = "user"
            
        let withName = "name = '\(name)'" // Case insensitive!
        let foldersOnly = "mimeType = 'application/vnd.google-apps.folder'"
        let ownedByUser = "'\(user.profile!.email)' in owners"
        query.q = "\(withName) and \(foldersOnly) and \(ownedByUser)"
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
                                     
            let folderList = result as! GTLRDrive_FileList

            // For brevity, assumes only one folder is returned.
            completion(folderList.files?.first?.identifier)
        }
    }
    
//    func populateFolderID() {
//            getFolderID(
//                name: "my-folder",
//                service: service,
//                user: user) { self.uploadFolderID = $0 }
//    }
    
    func uploadFile(
        name: String,
        folderID: String,
        fileURL: URL,
        mimeType: String,
        service: GTLRDriveService) {
        
        let file = GTLRDrive_File()
        file.name = name
        file.parents = [folderID]
        
        // Optionally, GTLRUploadParameters can also be created with a Data object.
        let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            // This block is called multiple times during upload and can
            // be used to update a progress indicator visible to the user.
        }
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            // Successful upload if no error is returned.
        }
    }

    func uploadMyFile() {
            let fileURL = Bundle.main.url(
                forResource: "my-image", withExtension: ".png")
            uploadFile(
                name: "my-image.jpeg",
                folderID: uploadFolderID!,
                fileURL: fileURL!,
                mimeType: "image/jpeg",
                service: service)
        }
    
    
    
    // acceleration
    
//    func startAccelerometers() {
//       // Make sure the accelerometer hardware is available.
//       if self.motion.isAccelerometerAvailable {
//          self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
//          self.motion.startAccelerometerUpdates()
//
//          // Configure a timer to fetch the data.
//           _ = Timer(fire: Date(), interval: (1.0/60.0),
//                repeats: true, block: { (timer) in
//             // Get the accelerometer data.
//             if let data = self.motion.accelerometerData {
//                let x = data.acceleration.x
//                let y = data.acceleration.y
//                let z = data.acceleration.z
//
//                // Use the accelerometer data in your app.
//                print("acceleration: ", x, y, z)
//             }
//          })
//
//          // Add the timer to the current run loop.
////           RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
//       }
//    }


}

//extension ViewController: MFMailComposeViewControllerDelegate {
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        if let _ = error {
//            self.dismiss(animated: true, completion: nil)
//        }
//        switch result {
//            case .cancelled:
//                print("Cancelled")
//                break
//            case .sent:
//                print("Mail sent successfully")
//                break
//            case .failed:
//                print("Sending mail failed")
//                break
//            default:
//                break
//        }
//        controller.dismiss(animated: true, completion: nil)
//    }
//}
