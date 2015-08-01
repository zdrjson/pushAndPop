//
//  PopAnimator.m
//  自定义 Push And Pop(花瓣转场动画)
//
//  Created by 张德荣 on 15/8/1.
//  Copyright (c) 2015年 JsonZhang. All rights reserved.
//

#import "PopAnimator.h"
#import "ViewController.h"
#import "DetailViewController.h"
@implementation PopAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DetailViewController * fromVc = (DetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController * toVc = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    UIView * snapshotView = [fromVc.detailImageView snapshotViewAfterScreenUpdates:NO];
    
    snapshotView.frame = [containerView convertRect:fromVc.detailImageView.frame fromView:fromVc.view];
//    NSLog(@"%@ %@",NSStringFromCGRect(fromVc.detailImageView.frame),NSStringFromCGRect(snapshotView.frame));
    fromVc.detailImageView.hidden = YES;
    
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    toVc.selectedCell.cellImageView.hidden = YES;
    [containerView insertSubview:toVc.view belowSubview:fromVc.view];
    [containerView addSubview:snapshotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapshotView.frame = [containerView convertRect:toVc.selectedCell.cellImageView.frame fromView:toVc.selectedCell];
        NSLog(@"%@ %@",NSStringFromCGRect(toVc.selectedCell.cellImageView.frame),NSStringFromCGRect(snapshotView.frame));
        fromVc.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        toVc.selectedCell.cellImageView.hidden = NO;
        [snapshotView removeFromSuperview];
        fromVc.detailImageView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    
}
@end
