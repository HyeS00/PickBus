//
//  ShrinkToCellTransition.swift
//  PickBus
//
//  Created by LeeJaehoon on 2022/12/07.
//

import UIKit

class ShrinkToCellTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration: TimeInterval = 0.42

    // 시간
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    // 애니메이션
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // 뷰 정보
        let containerView = transitionContext.containerView

        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }

        let toViewController = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to
        ) as! TransitInfoProtocol

        // 초기화
        let cellFrame = toViewController.getCellFrame()!

        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromView)

        fromView.setNeedsLayout()
        fromView.layoutIfNeeded()

        fromView.layer.masksToBounds = true
        fromView.layer.cornerRadius = 20

        // 애니메이션
        let animation1 = UIViewPropertyAnimator(duration: duration * 0.76, curve: .easeOut)
        animation1.addAnimations({
            fromView.frame = cellFrame
        })
        let animation2 = UIViewPropertyAnimator(duration: duration * 0.24, curve: .easeOut)
        animation2.addAnimations({
            fromView.alpha = 0
        })

        animation1.addCompletion { _ in
            animation2.startAnimation()
        }
        animation2.addCompletion { _ in
            transitionContext.completeTransition(true)
        }

        // 애니메이션 시작
        animation1.startAnimation()
    }
}
