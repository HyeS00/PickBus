//
//  BusBadgeView.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/23.
//

import UIKit

class BusBadgeView: UIView {

    // MARK: - Properties
    var busNum: String?

    private let busBadgeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bus.fill")
        imageView.tintColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var busBadgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = busNum
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    init(frame: CGRect, busNum: String) {
        super.init(frame: frame)
        self.busNum = busNum
        configureUI()
    }

    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
     */

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        configureUI()
    }

    // MARK: - Actions

    // MARK: - Helpers
    func configureUI() {
        backgroundColor = UIColor.duduDeepBlue
        frame = CGRect(
            x: 0,
            y: 0,
            width: busBadgeLabel.intrinsicContentSize.width + 42,
            height: 31
        )
        layer.cornerRadius = 8

        addSubview(busBadgeIcon)
        busBadgeIcon.widthAnchor
            .constraint(equalToConstant: 22).isActive = true
        busBadgeIcon.heightAnchor.constraint(equalToConstant: 19).isActive = true
        busBadgeIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        busBadgeIcon.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 7)
            .isActive = true

        addSubview(busBadgeLabel)
        busBadgeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        busBadgeLabel.leadingAnchor
            .constraint(equalTo: busBadgeIcon.trailingAnchor, constant: 5).isActive = true
    }
}
