//
//  ExtendFromCellTransition.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/12/07.
//

import UIKit

class ExtendFromCellTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration: TimeInterval = 0.8

    // 시간
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    // 애니메이션
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // 뷰 정보
        let containerView = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! TransitInfoProtocol

        // 초기화
        let cell = fromViewController.getCell()!
        let cellFrame = fromViewController.getCellFrame()!

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        toView.setNeedsLayout()
        toView.layoutIfNeeded()

        toView.layer.masksToBounds = true
        toView.layer.cornerRadius = cell.subviews[0].layer.cornerRadius
        toView.alpha = 0

        toView.frame = cellFrame

        // 애니메이션
        let animation1 = UIViewPropertyAnimator(duration: duration * 0.25, curve: .easeOut)
        animation1.addAnimations({
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })

        let animation2 = UIViewPropertyAnimator(duration: duration * 0.25, curve: .linear)
        animation2.addAnimations({
            cell.transform = .identity
            toView.alpha = 1
            toView.frame = containerView.bounds
        })

        let animation3 = UIViewPropertyAnimator(duration: duration * 0.25, curve: .linear)
        animation3.addAnimations({
            toView.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        })

        let animation4 = UIViewPropertyAnimator(duration: duration * 0.25, curve: .linear)
        animation4.addAnimations ({
            toView.transform = .identity
        })


        animation1.addCompletion { position in
            toView.alpha = 0.99
            animation2.startAnimation()
        }

        animation2.addCompletion { position in
            animation3.startAnimation()
        }

        animation3.addCompletion { position in
            animation4.startAnimation()
        }

        animation4.addCompletion { position in
            transitionContext.completeTransition(true)
        }

        // 애니메이션 시작
        animation1.startAnimation()

    }
}

