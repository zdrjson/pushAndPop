//
//  DetailViewController.m
//  自定义 Push And Pop(花瓣转场动画)
//
//  Created by 张德荣 on 15/8/1.
//  Copyright (c) 2015年 JsonZhang. All rights reserved.
//

#import "DetailViewController.h"
#import "PopAnimator.h"
@interface DetailViewController () <UINavigationControllerDelegate>
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition * percentDrivenTransition;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    
    //手势监听器
    UIScreenEdgePanGestureRecognizer * screenEdgePanGes = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgetPanGesture:)];
    screenEdgePanGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePanGes];
    
}

-(void)edgetPanGesture:(UIScreenEdgePanGestureRecognizer *)screenEdgePanGes
{
    CGFloat progress = [screenEdgePanGes translationInView:self.view].x / self.view.bounds.size.width;
    if (screenEdgePanGes.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [UIPercentDrivenInteractiveTransition new];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (screenEdgePanGes.state == UIGestureRecognizerStateChanged)
    {
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }
    else if (screenEdgePanGes.state == UIGestureRecognizerStateCancelled || screenEdgePanGes.state == UIGestureRecognizerStateEnded)
    {
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        }
        else
        {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
    
}
#pragma mark - UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return  [PopAnimator new];
    }
    return nil;
}
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[PopAnimator class]]) {
        return  self.percentDrivenTransition;
    }
    return nil;
}



@end
