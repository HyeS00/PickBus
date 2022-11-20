//
//  AddGroupTableViewCell.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/14.
//

import UIKit

class AddGroupTableViewCell: UITableViewCell {
    static let identifier = "AddGroupTableViewCell"

    private lazy var groupListAddLabel: UILabel = {
        let label = UILabel()
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "plus")
        let attachmentString = NSAttributedString(attachment: attachment)
        let contentString = NSMutableAttributedString(string: "")
        contentString.append(attachmentString)
        label.attributedText = contentString

        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 44/255.0, green: 53/255.0, blue: 122/255.0, alpha: 1.0)
        label.layer.masksToBounds = true
        label.layer.opacity = 0.3
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 15
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = CGSize(width: 2, height: 20)
        label.layer.shadowRadius = 2.0
        label.translatesAutoresizingMaskIntoConstraints = false

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
