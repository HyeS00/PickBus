//
//  RouteTableHeaderCell.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/15.
//

import UIKit

class RouteTableHeaderCell: UITableViewCell {

    // 정류장이름
    let busStopLabel: UILabel = {
        let label = UILabel()
        label.text = "정류장이름"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.contentView.addSubview(busStopLabel)

        NSLayoutConstraint.activate([
            self.busStopLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.busStopLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)

        ])
    }
}
