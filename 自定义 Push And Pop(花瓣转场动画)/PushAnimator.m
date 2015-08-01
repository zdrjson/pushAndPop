//
//  PushAnimator.m
//  自定义 Push And Pop(花瓣转场动画)
//
//  Created by 张德荣 on 15/8/1.
//  Copyright (c) 2015年 JsonZhang. All rights reserved.
//

#import "PushAnimator.h"
#import "ViewController.h"
#import "DetailViewController.h"
@implementation PushAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return  0.5;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1.获取动画的源控制器和目标控制器
    ViewController * fromVc = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DetailViewController * toVc = (DetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    //2.创建一个cell中imageView的截图，并把imageView隐藏，造成使户以为移动的就是imageView的假象
    UIView * snapshotView = [fromVc.selectedCell.cellImageView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [containerView convertRect:fromVc.selectedCell.cellImageView.frame fromView:fromVc.selectedCell];
//    NSLog(@"%@ %@",NSStringFromCGRect(snapshotView.frame),NSStringFromCGRect(fromVc.selectedCell.cellImageView.frame));
    fromVc.selectedCell.cellImageView.hidden = YES;
    
    //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来便为1
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    toVc.view.alpha = 0.0f;
    //4.都添加到 containerVeiw 中，注意顺序不能错了
    [containerView addSubview:toVc.view];
    [containerView addSubview:snapshotView];
    
    //5.执行动画
    [toVc.detailImageView layoutIfNeeded];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapshotView.frame = toVc.detailImageView.frame;
        toVc.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromVc.selectedCell.cellImageView.hidden = NO;
        toVc.detailImageView.image = toVc.detailImage;
        [snapshotView removeFromSuperview];
        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}
@end
