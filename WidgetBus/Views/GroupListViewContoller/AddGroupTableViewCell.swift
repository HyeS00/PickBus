//
//  AddGroupTableViewCell.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/14.
//

import UIKit

class AddGroupTableViewCell: UITableViewCell {
    static let identifier = "AddGroupTableViewCell"

    let groupAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        button.layer.opacity = 0.3
        button.backgroundColor = UIColor(red: 44/255.0, green: 53/255.0, blue: 122/255.0, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.contentView.addSubview(groupAddButton)
        groupAddButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        groupAddButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        groupAddButton.widthAnchor.constraint(equalToConstant: 361).isActive = true
        groupAddButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
