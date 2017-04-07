//
//  circleVC.m
//  collectionCircle
//
//  Created by smc on 2017/4/7.
//  Copyright © 2017年 SMC. All rights reserved.
//

#import "circleVC.h"
#import "circleView.h"
@interface circleVC ()
@property(nonatomic, strong) circleView *circle;
@property(nonatomic, strong) circleView *autocircle;
@property(nonatomic, strong) UIButton *tembackBtn;
@end

@implementation circleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.circle = [[circleView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 250)];
    [self.view addSubview:self.circle];
    
    self.autocircle = [[circleView alloc] initWithFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, 250)];
    self.autocircle.autoCircle = YES;
    [self.view addSubview:self.autocircle];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:0];
    backBtn.titleLabel.textColor = [UIColor blackColor];
    [backBtn setBackgroundColor:[UIColor blackColor]];
    [backBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(50, 50, 50, 30)];
    [window addSubview:backBtn];
    self.tembackBtn = backBtn;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.circle stopTimer];
    [self.autocircle stopTimer];
    [self.tembackBtn removeFromSuperview];
    
    
}

-(void)btnClicked{

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    
    
    
}

@end
