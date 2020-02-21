//
//  AppWebViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 26/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum webViewType {
    case privacyPolicy
    case termsAndConditions
    
    var title: String{
        switch self {
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsAndConditions:
            return "Terms and Conditions"
        }
    }
}
class AppWebViewController: UIViewController {
    
    
    //MARK: ------------------- Variables / Outlets  --------------------
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var screenTitle: CharacterSpaceLabel!
    @IBOutlet weak var webView: UIWebView!
    var type: webViewType = .privacyPolicy
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeView()
        self.loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         UIApplication.shared.isStatusBarHidden = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private
    func initializeView(){
        self.screenTitle.attributedText = String.createAttributedString(text: type.title, font: UIFont.openSensRegular(size: 18.0), color: UIColor.white, spacing: 2.2)
        self.lblSubTitle.text = type.title
        self.webView.isOpaque = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.webView.backgroundColor = UIColor.clear
    }
    
    private func loadWebView(){
        var url = ConfigurationManager.shared.appBaseURL()
        url = url.replacingOccurrences(of: "/api/", with: "/")
        url = url + (self.type == .privacyPolicy ? privacyPolicyEndPoint : termsConditionEndPoint)
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
}

