//
//  ViewController.m
//  StringHelper
//
//  Created by eric on 2017/11/13.
//  Copyright © 2017年 huangzhifei. All rights reserved.
//

#import "ViewController.h"
#import "NSString+verify.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError *error;
    NSString *ID = @"454879654215478964";
    NSLog(@"retCode: %d, error:%@", [ID validateIdentityStrong:&error], error.localizedDescription);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
