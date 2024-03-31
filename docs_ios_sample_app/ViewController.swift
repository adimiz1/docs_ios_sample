//
//  ViewController.swift
//  docs_ios_sample_app
//
//  Created by Adi Mizrahi on 31/03/2024.
//

import UIKit
import Cloudinary
class ViewController: UIViewController {

    var cloudName: String = "<your_cloudname>" // need to config for configuration
    var uploadPreset: String = "<your_upload_preset>" // need to config for upload
    var publicId: String = "<your_public_id>" // need to config for url generation

    @IBOutlet weak var ivGenerateUrl: CLDUIImageView!
    @IBOutlet weak var ivUploadedImage: CLDUIImageView!

    var cloudinary: CLDCloudinary!
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        initCloudinary()
        generateUrl()
        uploadImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        setImageView()
    }

    private func initCloudinary() {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }

    private func generateUrl() {
        url = cloudinary.createUrl().setTransformation(CLDTransformation().setEffect("sepia")).generate(publicId)
    }

    private func setImageView() {
        ivGenerateUrl.cldSetImage(url, cloudinary: cloudinary)
    }

    private func uploadImage() {
        guard let data = UIImage(named: "cloudinary_logo")?.pngData() else {
            return
        }
        cloudinary.createUploader().upload(data: data, uploadPreset: uploadPreset) { response, error in
            DispatchQueue.main.async {
                guard let url = response?.secureUrl else {
                    return
                }
                self.ivUploadedImage.cldSetImage(url, cloudinary: self.cloudinary)
            }
        }
    }


}

