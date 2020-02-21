//
//  NotificationView.swift
//
//  Created by Monu on 11/07/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

enum NotificationType {
    case success
    case error

    var color: UIColor {
        switch self {
        case .success:
            return UIColor(red: 31.0 / 255.0, green: 186.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
        case .error:
            return UIColor(red: 255.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
        }
    }
}

class NotificationView: UIView {

    // MARK: - Properties

    fileprivate let displayTime = 5.0 // Seconds

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!

    fileprivate class func instanceFromNib() -> NotificationView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NotificationView
    }

    /// Dissmiss notification view.
    ///
    /// - Parameter sender: UIButton
    @IBAction func dissmissButtonTapped(_: UIButton) {
        hide()
    }
}

extension NotificationView {

    // MARK: - Public methods

    /// Show message in notification form.
    ///
    /// - Parameter error: Error occure and you want to show in notification.
    class func showError(_ error: Error?) {
        guard let message = error?.localizedDescription else { return }
        if let err = error as NSError?, err.code == -999 { return }
        NotificationView.showMessage(message, type: .error)
    }

    /// Show message in notification form.
    ///
    /// - Parameters:
    ///   - successMessage: Notification message.
    class func showSuccess(_ successMessage: String?) {
        guard let message = successMessage else { return }
        NotificationView.showMessage(message, type: .success)
    }

    class func showErrorMessage(_ errorMessage: String?) {
        guard let message = errorMessage else { return }
        NotificationView.showMessage(message, type: .error)
    }

    /// Show message in notification form.
    ///
    /// - Parameters:
    ///   - successMessage: Notification message.
    ///   - type: Notification type like as success, error, info etc.
    class func showMessageWithType(_ successMessage: String?, type: NotificationType) {
        guard let message = successMessage else { return }
        NotificationView.showMessage(message, type: type)
    }
}

extension NotificationView {

    // MARK: - Private methods

    fileprivate class func showMessage(_ message: String, type: NotificationType) {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            let alertView = NotificationView.instanceFromNib()
            alertView.messageLabel.text = message
            alertView.backgroundColor = type == .error ? UIColor.toastBackgroundColor() : UIColor.toastBackgroundSuccess()
            alertView.iconImageView.image = type == .error ? #imageLiteral(resourceName: "ic_warning") : #imageLiteral(resourceName: "ic_Success")
            alertView.addAlertOnWindow(window, message: message)
        }
    }

    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = (-1.0 * self.frame.height)
        }) { _ in
            self.removeFromSuperview()
        }
    }

    private func addAlertOnWindow(_ window: UIWindow, message: String) {
        let height = message.textHeight(UIScreen.main.bounds.width - 50, font: messageLabel.font) + 25
        frame = CGRect(x: 10, y: -1.0 * height, width: UIScreen.main.bounds.width - 20, height: height)
        // Show alert view
        window.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = UIApplication.shared.statusBarFrame.height + 10
        }) { _ in
            // Hide view
            self.perform(#selector(self.hide), with: nil, afterDelay: self.displayTime)
        }
    }
}

extension String {

    // MARK: - String Extension

    /// Get string height with corrosponding the with.
    ///
    /// - Parameters:
    ///   - width: CGFloat Fixed width.
    ///   - font: UIFont of label or textFields.
    /// - Returns: Height of the content size.
    func textHeight(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}
