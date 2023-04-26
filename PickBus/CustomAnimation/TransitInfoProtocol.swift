//
//  TransitInfoProtocol.swift
//  PickBus
//
//  Created by LeeJaehoon on 2022/12/07.
//

import UIKit

protocol TransitInfoProtocol {
    var view: UIView! { get set }

    func getCellFrame() -> CGRect?

    func getCell() -> UITableViewCell?
}
