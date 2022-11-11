//
//  NSObject+.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/11.
//

import Foundation

// 뷰에에 identifier 작성 생략 가능
extension NSObject {
    static var identifier: String {
        String(describing: self)
    }
}
