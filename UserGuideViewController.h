//
//  UserGuideViewController.h
//  Study
//
//  Created by MaxPlus on 15/9/17.
//  Copyright (c) 2015年 MaxPlus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@interface UserGuideViewController : UIViewController <UIScrollViewDelegate>

@property (strong ,nonatomic) UIScrollView *scrollView;
@property (strong ,nonatomic) UIView *contentView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (assign ,nonatomic) CGSize size;


@end
