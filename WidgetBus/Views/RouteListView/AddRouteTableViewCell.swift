//
//  AddRouteTableViewCell.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class AddRouteTableViewCell: UITableViewCell {

    // 루트추가 이미지
    private let addImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    // 루트추가 문구
    private let addLabel: UILabel = {
        let label = UILabel()
        label.text = "새 경로를 추가해주세요"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(addImageView)
        self.contentView.addSubview(addLabel)

        NSLayoutConstraint.activate([
//            self.contentView.heightAnchor.constraint(equalToConstant: 78),
            addImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            addImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            addLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            addLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
}
