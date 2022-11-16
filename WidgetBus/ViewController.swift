//
//  ViewController.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/10/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var jerryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func uploadJerryView(_ sender: Any) {
        let selectVC = SelectArrivalViewController()
        self.navigationController?.pushViewController(selectVC, animated: false)
    }
}
