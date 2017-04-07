//
//  ViewController.m
//  collectionCircle
//
//  Created by smc on 2017/4/7.
//  Copyright © 2017年 SMC. All rights reserved.
//

#import "ViewController.h"
#import "circleVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  


}
- (IBAction)btnClicked:(id)sender {
    
    circleVC *vc = [[circleVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}


-(void)dealloc{


}


@end
