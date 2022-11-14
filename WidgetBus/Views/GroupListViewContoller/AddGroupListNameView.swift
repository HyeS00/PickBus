//
//  AddGroupListNameView.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/13.
//

import UIKit

final class AddGroupListNameViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentTextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
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
        groupListTextfield.frame = CGRect(x: 200, y: 200, width: 300, height: 90)
        groupListTextfield.placeholder = "출발지를 입력해주세요"
        groupListTextfield.borderStyle = .roundedRect
        return groupListTextfield
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 44/255.0, green: 53/255.0, blue: 122/255.0, alpha: 1.0)

        setupNavigationController()
        setupLayout()

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
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        self.view.addSubview(contentTextView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        contentView.addSubview(viewLabel)
        viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -50).isActive = true
        viewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        contentView.addSubview(indicatorImage)
        indicatorImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        indicatorImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        indicatorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorImage.topAnchor.constraint(equalTo: viewLabel.topAnchor, constant: 130).isActive = true
        indicatorImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

//        contentTextView.addSubview(groupListTextfield)
//        indicatorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        groupListTextfield.topAnchor.constraint(equalTo: indicatorImage.topAnchor, constant: 10).isActive = true
//        groupListTextfield.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

}
extension AddGroupListNameViewController: UITextFieldDelegate {
}
