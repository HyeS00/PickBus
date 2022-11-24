//
//  TestViewController.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/23.
//

import UIKit

class TestViewController: BackgroundViewController {

    // MARK: - Properties
    var busNum: String?

    private lazy var busBadgeView: BusBadgeView = {
        let view = BusBadgeView(frame: .zero, busNum: self.busNum ?? "버스번호미입력")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setTitleAndIndicator(titleText: "제목1231231", indicatorStep: .stepTwo)

//        busNum = "207번 (지곡행)"

        configureUI()
    }
    // MARK: - Actions

    // MARK: - Helpers
    func configureUI() {
        super.bottomView.addSubview(busBadgeView)
        busBadgeView.widthAnchor
            .constraint(equalToConstant: busBadgeView.frame.width).isActive = true
        busBadgeView.heightAnchor.constraint(equalToConstant: busBadgeView.frame.height).isActive = true
        busBadgeView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 9).isActive = true
        busBadgeView.trailingAnchor
            .constraint(equalTo: bottomView.trailingAnchor, constant: -17).isActive = true
    }
}
