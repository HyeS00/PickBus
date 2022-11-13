//
//  GroupListViewContoller.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/11.
//

import UIKit

final class GroupListViewContoller: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupMainView()
    }
}

private extension GroupListViewContoller {
    func setupNavigationController() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = "뜌벅초"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)

        let button = UIButton(type: .system)
        let buttonImage = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        button.setImage(UIImage(systemName: "gearshape", withConfiguration: buttonImage), for: .normal)
        button.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        button.tintColor = .black
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func pressButton(_ sender: UIBarButtonItem) {
        let settingView = SettingViewController()
        self.navigationController?.pushViewController(settingView, animated: true)
    }
}

private extension GroupListViewContoller {
    func setupMainView() {
        let mainLabel = UILabel()
        mainLabel.text = "그룹을 \n추가해주세요."
        mainLabel.numberOfLines = 2
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        self.view.addSubview(mainLabel)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let addButton = UIButton()
        addButton.setTitle("추가하기", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = .blue
        addButton.layer.opacity = 0.3
        addButton.layer.cornerRadius = 15
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 1.0
        addButton.layer.shadowOffset = CGSize.zero
        addButton.layer.shadowRadius = 2
        self.view.addSubview(addButton)

        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 70).isActive = true
        addButton.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 361).isActive = true
        addButton.addTarget(self, action: #selector(btnAddGroupList(_:)), for: .touchUpInside)
    }

    @objc func btnAddGroupList(_ sender: UIButton) {
        let addGroupListNameView = AddGroupListNameViewController()
        self.navigationController?.pushViewController(addGroupListNameView, animated: true)
    }
}
