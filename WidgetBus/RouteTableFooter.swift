//
//  RouteTableFooter.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteTableFooter: UITableViewHeaderFooterView {
    static let identifier = "RouteTableFooter"

    // 라운드
    let roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(roundView)

        NSLayoutConstraint.activate([
//            self.contentView.heightAnchor.constraint(equalToConstant: 15),
            self.roundView.heightAnchor.constraint(equalToConstant: 30),
            self.roundView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            self.roundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
