//
//  RouteTableViewCell.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    static let identifier = "RouteTableViewCell"

    // 버스번호
    private let busNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .black
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 버스남은시간
    private let busRemainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 다음버스남은시간
    private let nextBusRemainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 탑승버튼
    private let rideButton: UIButton = {
        let button = UIButton()
        button.setTitle("탑승", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(busNumberLabel)
        self.contentView.addSubview(busRemainingTimeLabel)
        self.contentView.addSubview(nextBusRemainingTimeLabel)
        self.contentView.addSubview(rideButton)

        NSLayoutConstraint.activate([
//            self.contentView.heightAnchor.constraint(equalToConstant: 52),

            // 버스번호
            busNumberLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            busNumberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            busNumberLabel.widthAnchor.constraint(equalToConstant: 80),
            busNumberLabel.heightAnchor.constraint(equalToConstant: 30),

            // 버스남은시간
            busRemainingTimeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            busRemainingTimeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),

            // 다음버스남은시간
            nextBusRemainingTimeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            nextBusRemainingTimeLabel.leadingAnchor.constraint(equalTo: self.busRemainingTimeLabel.trailingAnchor, constant: 14),

            // 탑승버튼
            rideButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            rideButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            rideButton.widthAnchor.constraint(equalToConstant: 38),
            rideButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        // 샘플
        busNumberLabel.text = "5007"
        busRemainingTimeLabel.text = "전전"
        nextBusRemainingTimeLabel.text = "7분전"
    }
}
