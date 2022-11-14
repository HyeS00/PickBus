//
//  AddGroupListNameView.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/13.
//

import UIKit

final class AddGroupListNameViewController: UIViewController {

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        return view
    }()

    private let viewLabel: UILabel = {
        let viewLabel = UILabel()
        viewLabel.text = "어떨때 이용하는 \n대중교통인가요?"
        viewLabel.numberOfLines = 2
        viewLabel.textAlignment = .center
        viewLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        viewLabel.textColor = .white
        viewLabel.translatesAutoresizingMaskIntoConstraints = false

        return viewLabel
    }()

    let indicatorImage: UIImageView = {
        let indicatorImage = UIImageView()
        indicatorImage.image = UIImage(named: "ProgressIndicator.png")
        indicatorImage.translatesAutoresizingMaskIntoConstraints = false

        return indicatorImage
    }()

    let groupListTextfield: UITextField = {
        var groupListTextfield = UITextField()
        groupListTextfield.frame = CGRect(x: 15, y: 10, width: 361, height: 75)
        groupListTextfield.font = UIFont(name: "SFUI-Regular", size: 70)
        groupListTextfield.placeholder = "출발지를 입력해주세요"
        groupListTextfield.layer.shadowColor = UIColor.black.cgColor
        groupListTextfield.layer.shadowOpacity = 0.3
        groupListTextfield.layer.shadowOffset = CGSize(width: 0, height: 2)
        groupListTextfield.layer.shadowRadius = 2
        groupListTextfield.borderStyle = .roundedRect
        groupListTextfield.clearButtonMode = .whileEditing

        return groupListTextfield
    }()

    private let bottomViewLabel: UILabel = {
        let viewLabel = UILabel()
        viewLabel.text = "버스로 자주다니는 곳을 등록해 보세요!"
        viewLabel.textAlignment = .center
        viewLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        viewLabel.textColor = .gray
        viewLabel.translatesAutoresizingMaskIntoConstraints = false

        return viewLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 44/255.0, green: 53/255.0, blue: 122/255.0, alpha: 1.0)

        setupNavigationController()
        setupLayout()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.groupListTextfield.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.groupListTextfield.resignFirstResponder()
    }
}

private extension AddGroupListNameViewController {
    func setupNavigationController() {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    @objc func pressButton(_ sender: UIBarButtonItem) {
        let settingView = SettingViewController()
        self.navigationController?.pushViewController(settingView, animated: true)
    }
}

private extension AddGroupListNameViewController {
    func setupLayout() {
        self.view.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        contentView.addSubview(viewLabel)
        viewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100).isActive = true
        viewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        viewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        viewLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true

        contentView.addSubview(indicatorImage)
        indicatorImage.topAnchor.constraint(equalTo: viewLabel.topAnchor, constant: 80).isActive = true
        indicatorImage.centerXAnchor.constraint(equalTo: viewLabel.centerXAnchor).isActive = true
        indicatorImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        indicatorImage.heightAnchor.constraint(equalToConstant: 30).isActive = true

        contentView.addSubview(bottomView)
        bottomView.topAnchor.constraint(equalTo: indicatorImage.topAnchor, constant: 50).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        bottomView.addSubview(groupListTextfield)

        bottomView.addSubview(bottomViewLabel)
        bottomViewLabel.topAnchor.constraint(equalTo: groupListTextfield.topAnchor, constant: 100)
            .isActive = true
        bottomViewLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        bottomViewLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true

    }
}
extension AddGroupListNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.groupListTextfield.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
