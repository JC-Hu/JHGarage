//
//  ViewController.m
//  JHGarage
//
//  Created by Jason Hu on 2018/11/22.
//  Copyright © 2018 Jason Hu. All rights reserved.
//

#import "ViewController.h"

#import "JHGarage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSLog(@"1");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"2");
}

- (IBAction)buttonAction:(id)sender {
    
    
    [self.navigationController pushViewController:[ViewController new] animated:YES];
    
}

- (void)dealloc
{
    NSLog(@"123hhh");
}

@end
