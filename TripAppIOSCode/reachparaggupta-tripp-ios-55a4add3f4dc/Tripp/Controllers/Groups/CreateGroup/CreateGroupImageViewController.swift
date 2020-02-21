//
//  CreateGroupImageViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 01/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class CreateGroupImageViewController: UIViewController {
    
    //MARK: IBOutlet/variables
    @IBOutlet weak var nextButton: RoundedBorderButton!
    @IBOutlet weak var changeImageButton: RoundedBorderButton!
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var updateImageButton: UIButton!
    
    weak var delegate: CreateGroupWalkthroughViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - private
    private func setupUI(){
        nextButton.addCharacterSpace(space: -0.3)
        nextButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
        changeImageButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 9)
        updateImageButton.isHidden = changeImageButton.currentImage == nil
        changeImageButton.imageView?.contentMode = .scaleAspectFill
        setupForEditMode()
    }
    private func setupForEditMode() {
        if let imageUrl = delegate?.group.image, imageUrl.isEmpty == false {
            changeImageButton.imageView?.imageFromS3(imageUrl, handler: { [weak self] image in
                self?.changeImageButton.setImage(image, for: .normal)
                self?.updateImageButton.isHidden = self?.changeImageButton.currentImage == nil
            })
        }
        if let group = delegate?.group, group.groupId != 0 {
            nextButton.setTitle("Update Group", for: .normal)
        }
    }
    //MARK: IBActions
    @IBAction func nextTapped(_ sender: Any) {
        guard let delegate = self.delegate else {
            return
        }
        var msg = "Group created"
        var groupId: Int? = nil
        if delegate.group.groupId != 0 {
            msg = "Group updated successfuly"
            groupId = delegate.group.groupId
        }
        AppLoader.showLoader()
        APIDataSource.createGroup(service: .createGroup(name: delegate.group.name, image: delegate.group.image ?? "", groupId: groupId)) { [weak self] (group, message) in
            AppLoader.hideLoader()
            if let group = group {
                AppToast.showSuccessMessage(message: msg)
                if groupId == nil {
                    self?.delegate?.showNextPage()
                    delegate.group.groupId = group.groupId
                } else {
                    delegate.group.updateGroupNameAndImageUrl(group)
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                    
                }
            } else {
                AppToast.showErrorMessage(message: message!)
            }
        }
       
    }
    @IBAction func changeImageTapped(_ sender: UIButton) {
        openImagePickerController(sender: sender)
    }

}
