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

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var jerryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stackView.addArrangedSubview(moveRouteListViewButton)
    }

    @IBAction func uploadJerryView(_ sender: Any) {
        let selectVC = SelectArrivalViewController()
        self.navigationController?.pushViewController(selectVC, animated: false)
    }

    @objc func pressedMoveRouteListViewButton(_ sender: UIButton) {
        let routeListvc = RouteListViewController()
        navigationController?.pushViewController(routeListvc, animated: true)
    }
}
