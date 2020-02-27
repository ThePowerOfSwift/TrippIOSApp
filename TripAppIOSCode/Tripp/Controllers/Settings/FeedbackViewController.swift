//
//  FeedbackViewController.swift
//  Tripp
//
//  Created by Monu on 28/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController {

    @IBOutlet weak var commentTextView: PlaceholderTextView!
    @IBOutlet weak var sendFeedbacksButton: RoundedBorderButton!
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    private func setupView(){
        self.commentTextView.placeholder = feedbackCommentPlaceholder
        self.commentTextView.textContainerInset = UIEdgeInsetsMake(11, 17, 11, 17);
        self.sendFeedbacksButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22.0)
    }
    
    // MARK: - Validations
    func isValidateTextFields() -> Bool
    {
        if self.commentTextView.isEmpty(){
            AppToast.showErrorMessage(message: feedbackEmaptyValidation)
            return false
        }
        
        return true
    }
    
    //MARK: IBAction Methods
    @IBAction func sendFeedbackButtonTapped(_ sender: Any) {
        if isValidateTextFields(){
            sendFeedback()
        }
    }
    
    /**
     * @method sendFeedback
     * @discussion Send Feedback API.
     */
    private func sendFeedback(){
        self.view.endEditing(true)
        AppLoader.showLoader()
        APIDataSource.sendFeedback(service: .sendFeedback(feedback: self.commentTextView.text)) { (message, errorMessage) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showSuccessMessage(message: feedbackSentMessage)
                self.commentTextView.text = ""
                self.popViewController()
            }
            else {
                AppToast.showErrorMessage(message: errorMessage!)
            }
        }
    }
}
