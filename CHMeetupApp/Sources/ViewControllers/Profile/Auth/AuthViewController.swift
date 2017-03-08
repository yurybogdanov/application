//
//  AuthViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import SafariServices

class AuthViewController: UIViewController, ProfileHierarhyViewControllerType {

  @IBOutlet var authButtons: [UIButton]! {
    didSet {
      for button in authButtons {
        button.layer.cornerRadius = Constants.SystemSizes.cornerRadius
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.appFont(.gothamProMedium(size: 15))
      }
    }
  }

  @IBOutlet var infoLabel: UILabel! {
    didSet {
      infoLabel.font = UIFont.appFont(.systemFont(size: 15))
    }
  }

  var safariViewController: SFSafariViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(loggedIn(_:)),
                                           name: .CloseSafariViewControllerNotification,
                                           object: nil)
  }

  @IBAction func vkLoginButtonAction(_ sender: UIButton) {
    login(app: LoginType.vk)
  }

  @IBAction func fbLoginButtonAction(_ sender: UIButton) {
    login(app: LoginType.fb)
  }

}

// MARK: - Login actions
extension AuthViewController {

  func login(app: LoginType) {
    if !app.isAppExists {
      let url = app.urlAuth
      showSafariViewController(url: url)
    } else {
      let url = app.schemeAuth
      if let url = url {
        UIApplication.shared.open(url, options: [:])
      } else {
        assertionFailure("Error: you didn't recieve url from notification")
      }
    }
  }

  func loggedIn(_ notification: Notification? = nil) {
    // TODO: get url and token
    if let safariViewController = safariViewController {
      if safariViewController.isViewLoaded {
        safariViewController.dismiss(animated: true, completion: nil)
      }
    }
    LoginProcessViewController.isLogin = true
    profileNavigationController?.updateRootViewController()
  }

}

// MARK: - Working with safariViewController
extension AuthViewController {
  func showSafariViewController(url: URL) {
    safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
    self.present(safariViewController!, animated: true, completion: nil)
  }
}