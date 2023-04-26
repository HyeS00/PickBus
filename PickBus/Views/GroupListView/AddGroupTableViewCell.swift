//
//  AddGroupTableViewCell.swift
//  PickBus
//
//  Created by Shin yongjun on 2022/11/14.
//

import UIKit

class AddGroupTableViewCell: UITableViewCell {
//    static let identifier = "AddGroupTableViewCell"

    private lazy var groupListAddLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = .systemFont(ofSize: 70, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .duduDeepBlue
        label.layer.masksToBounds = true
        label.layer.opacity = 0.3
        label.layer.cornerRadius = 15
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = CGSize(width: 2, height: 20)
        label.layer.shadowRadius = 2.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.contentView.addSubview(groupListAddLabel)
        groupListAddLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        groupListAddLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        groupListAddLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        groupListAddLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15)
            .isActive = true
        groupListAddLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
