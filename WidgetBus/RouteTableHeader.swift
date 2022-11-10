//
//  RouteTableHeader.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteTableHeader: UITableViewHeaderFooterView {
    static let identifier = "RouteTableHeader"

    // 정류장이름
    private let busStopLabel: UILabel = {
        let label = UILabel()
        label.text = "정류장이름"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(busStopLabel)

        NSLayoutConstraint.activate([
//            self.contentView.heightAnchor.constraint(equalToConstant: 36),
            self.busStopLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.busStopLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        ])
    }
}
