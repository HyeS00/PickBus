//
//  ViewController.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/10/25.
//

import UIKit

class ViewController: UIViewController {
    private lazy var moveRouteListViewButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 500, width: 200, height: 50))
        button.setTitle("루트리스트뷰", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(pressedMoveRouteListViewButton(_ :)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(moveRouteListViewButton)
        // Do any additional setup after loading the view.
    }

    @objc func pressedMoveRouteListViewButton(_ sender: UIButton) {
        let routeListvc = RouteListViewController()
        navigationController?.pushViewController(routeListvc, animated: true)
    }
}
