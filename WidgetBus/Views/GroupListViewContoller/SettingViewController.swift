//
//  SecondViewController.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/13.
//

import UIKit

final class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()

        let isPushOn = UIApplication.shared.isRegisteredForRemoteNotifications

        if isPushOn {
            print("push on")
            // disable
            UIApplication.shared.unregisterForRemoteNotifications()
        } else {
            print("push off")
            // enable
            UIApplication.shared.registerForRemoteNotifications()
        }

    }
}
private extension SettingViewController {
    func setupNavigationController() {
        let button = UIButton(type: .system)
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
