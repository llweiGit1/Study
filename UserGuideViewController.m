//
//  UserGuideViewController.m
//  Study
//
//  Created by MaxPlus on 15/9/17.
//  Copyright (c) 2015年 MaxPlus. All rights reserved.
//

#import "UserGuideViewController.h"
#import "LoginViewController.h"

@interface UserGuideViewController ()

@property (strong,nonatomic) UIImageView *iv1;
@property (strong,nonatomic) UIImageView *iv2;
@property (strong,nonatomic) UIImageView *iv3;
@property (strong,nonatomic) UIImageView *iv4;
@property (strong,nonatomic) UIImageView *iv5;
@property (strong, nonatomic) UIButton *startButton;

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGuide];
}

- (void)initGuide {
    //获取屏幕尺寸
    self.size = [[UIScreen mainScreen] bounds].size;
    //设置滚动视图的frame
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 设置滚动视图不显示滚动针
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //设置滚动视图支持分页，取消弹簧效果
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    //设置滚动视图的contentSize
    self.scrollView.contentSize = CGSizeMake(self.size.width * 4, self.size.height);
    //设置contentView的size
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width * 4, self.size.height)];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
    //如果你不想让scroll view的内容自动调整，将这个属性设为NO（默认值YES）
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置滚动视图的代理
    self.scrollView.delegate = self;
    
    //设置pageControl的frame并初始化
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.size.width * (2.0 / 5.0), self.size.height * (7.0 / 8.0), self.size.width * (1.0 / 5.0), 39)];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    //设置contentView的子视图
    [self imageViews];
    //    NSLog(@"设置contentView的子视图");
    //添加子视图
    [self.scrollView addSubview:self.contentView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

- (void)imageViews {
    //设置图像视图
    self.iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    self.iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.size.width, 0, self.size.width, self.size.height)];
    self.iv3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.size.width * 2, 0, self.size.width, self.size.height)];
    self.iv4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.size.width * 3, 0, self.size.width, self.size.height)];
    //    UIImageView *iv5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.size.width * 4, 0, self.size.width, self.size.height)];
    self.iv4.userInteractionEnabled = YES;
    
    self.iv1.image = [UIImage imageNamed:@"老师页.png"];
    self.iv2.image = [UIImage imageNamed:@"学生页.png"];
    self.iv3.image = [UIImage imageNamed:@"家长页.png"];
    self.iv4.image = [UIImage imageNamed:@"好学升页.png"];
    
    self.startButton = [[UIButton alloc] init];
    self.startButton.frame = CGRectMake(self.size.width * (1.0 / 3.0), self.size.height * (2.0 / 3.0), self.size.width * (1.0 / 3.0), self.size.width * (1.0 / 9.0));
    [self.startButton setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.iv4 addSubview:self.startButton];
    
    
    
    //设置pageControl的页数
    self.pageControl.numberOfPages = 4;
    
    //    UITapGestureRecognizer *singTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPress:)];
    
    //    [iv5 addGestureRecognizer:singTap1];
    
    
    [self.contentView addSubview:self.iv1];
    [self.contentView addSubview:self.iv2];
    [self.contentView addSubview:self.iv3];
    [self.contentView addSubview:self.iv4];
    //    [self.contentView addSubview:iv5];
    //    NSLog(@"设置成功");
    
}

- (void)buttonPress:(id)sender {
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    [self.view.window.layer addAnimation:animation forKey:nil];
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    [self presentViewController:[loginSB instantiateInitialViewController] animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
        return NO;
} 



#pragma marks - scrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int i = scrollView.contentOffset.x /self.size.width;
    self.pageControl.currentPage = i;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
