//
//  SecondViewController.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/13.
//

import UIKit

final class SettingViewController: UIViewController {

    let notiLabel: UILabel = {
        let noti = UILabel()
        noti.text = "설정"
        return noti
    }()

    lazy var notiSetting: UISwitch = {
        let noti = UISwitch()
        noti.tintColor = UIColor.orange
        noti.isOn = true
        noti.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        return noti
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .black
    }

    @objc func onClickSwitch(sender: UISwitch) {
           var text: String!
           var color: UIColor!

           if sender.isOn {
               text = "On"
               color = UIColor.gray
           } else {
               text = "Off"
               color = UIColor.orange
           }

           self.notiLabel.text = text
           self.notiLabel.backgroundColor = color
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

private extension SettingViewController {
    func setupLayout() {
        view.addSubview(notiSetting)
        notiSetting.translatesAutoresizingMaskIntoConstraints = false
        notiSetting.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notiSetting.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(notiLabel)

    }
}
