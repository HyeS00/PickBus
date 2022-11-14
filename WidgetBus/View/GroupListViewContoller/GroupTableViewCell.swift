//
//  GroupListTableViewCell.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/14.
//

import UIKit

protocol ContentsMainTextDelegate: AnyObject {
    func catergoryButtonTapped()
}
class GroupTableViewCell: UITableViewCell {

    static let identifier = "GroupListCell"

    var cellDelegate: ContentsMainTextDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.groupListButton.addTarget(self, action: #selector(groupClicked), for: .touchUpInside)
        setupLayout()
    }

    let groupListButton: UIButton = {
        let button = UIButton()
        button.setTitle("출근길", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.contentView.addSubview(groupListButton)
        groupListButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        groupListButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        groupListButton.widthAnchor.constraint(equalToConstant: 361).isActive = true
        groupListButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }

    @objc func groupClicked() {
        cellDelegate?.catergoryButtonTapped()
    }
}
