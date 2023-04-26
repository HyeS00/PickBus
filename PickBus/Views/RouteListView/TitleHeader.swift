//
//  RouteTableHeader.swift
//  PickBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

final class TitleHeader: UITableViewHeaderFooterView {

    var isEditinMode: Bool = false {
        didSet {
            deleteButton.imageView?.tintColor = isEditinMode ? .clear : .red
            deleteButton.isEnabled = !isEditinMode
            editButton.imageView?.tintColor = isEditinMode ? .clear : .white
            editButton.isEnabled = !isEditinMode

        }
    }

    // 정류장이름
    let busStopLabel: UILabel = {
        let label = UILabel()
        label.text = "출근"
        label.textColor = .white
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(busStopLabel)
        self.contentView.addSubview(deleteButton)
        self.contentView.addSubview(editButton)

        NSLayoutConstraint.activate([
            self.busStopLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.busStopLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            // 삭제버튼
            self.deleteButton.heightAnchor.constraint(equalToConstant: 26),
            self.deleteButton.widthAnchor.constraint(equalToConstant: 26),
            self.deleteButton.trailingAnchor.constraint(equalTo: busStopLabel.leadingAnchor, constant: -10),
            self.deleteButton.centerYAnchor.constraint(equalTo: busStopLabel.centerYAnchor),

            // 수정버튼
            self.editButton.heightAnchor.constraint(equalToConstant: 20),
            self.editButton.widthAnchor.constraint(equalToConstant: 20),
            self.editButton.leadingAnchor.constraint(equalTo: busStopLabel.trailingAnchor, constant: 10),
            self.editButton.centerYAnchor.constraint(equalTo: busStopLabel.centerYAnchor)
        ])
    }
}
