//
//  RouteTableViewCell.swift
//  PickBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

final class RouteCell: UITableViewCell {

    var closure: (() -> Void)?

    // 버스번호
    var busNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 버스번호 배경
    private lazy var busNumberBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .duduDeepBlue
        view.layer.cornerRadius = 9
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // 버스남은시간
    lazy var busRemainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 남은정류장
    lazy var arrprevstationcnt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .duduGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 탑승버튼
    private lazy var rideButton: UIButton = {
        let button = UIButton()
        button.setTitle("탑승", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.duduDeepBlue, for: .normal)
        button.backgroundColor = .duduBlue
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.duduDeepBlue?.cgColor
        button.addTarget(self, action: #selector(pressedRideButton(_ :)), for: .touchUpInside)
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
        self.contentView.addSubview(busNumberBackgroundView)
        self.contentView.addSubview(busNumberLabel)
        self.contentView.addSubview(busRemainingTimeLabel)
        self.contentView.addSubview(arrprevstationcnt)
        self.contentView.addSubview(rideButton)

        NSLayoutConstraint.activate([
            // 버스번호 배경
            busNumberBackgroundView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            busNumberBackgroundView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor, constant: 16),
            busNumberBackgroundView.widthAnchor.constraint(equalToConstant: 80),
            busNumberBackgroundView.heightAnchor.constraint(equalToConstant: 30),

            // 버스번호
            busNumberLabel.centerYAnchor.constraint(equalTo: busNumberBackgroundView.centerYAnchor),
            busNumberLabel.centerXAnchor.constraint(equalTo: busNumberBackgroundView.centerXAnchor),
            busNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            busNumberLabel.heightAnchor.constraint(equalToConstant: 30),

            // 버스남은시간
            busRemainingTimeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            busRemainingTimeLabel.leadingAnchor.constraint(
                equalTo: self.contentView.centerXAnchor, constant: -20),

            // 남은정류장
            arrprevstationcnt.bottomAnchor.constraint(
                equalTo: self.busRemainingTimeLabel.bottomAnchor),
            arrprevstationcnt.leadingAnchor.constraint(
                equalTo: self.busRemainingTimeLabel.trailingAnchor,
                constant: 14),

            // 탑승버튼
            rideButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rideButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rideButton.widthAnchor.constraint(equalToConstant: 38),
            rideButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func pressedRideButton(_ sender: UIButton) {
        // 버스번호 넘기면서 디테일뷰로 이동
        closure?()
    }
}
