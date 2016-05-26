//
//  RootViewController.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/3.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionPushViewController:(id)sender
{
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionPresentViewController:(id)sender
{
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [self.navigationController presentViewController:vc animated:YES completion:^{
        // TODO:
    }];
}

@end
