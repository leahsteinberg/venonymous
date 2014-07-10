//
//  VenonViewController.m
//  venon
//
//  Created by Leah Steinberg on 6/30/14.
//  Copyright (c) 2014 LeahSteinberg. All rights reserved.
//

#import "VenonViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>


@interface VenonViewController ()
- (IBAction)venonLogInButton:(UIButton *)sender;

@end

@implementation VenonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)venonLogInButton:(UIButton *)sender {
    NSLog(@"hsldfjdskfjHIIII");
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile, VENPermissionAccessFriends]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                 NSLog(@"sucess!!!");
                                 [self presentLoggedInVC];
                             }
                             else {
                                 NSLog(@"errorr");
                                 
                                 
                             }
                         }];
    
    
    
}



-(void)presentLoggedInVC{
    NSLog(@"should be presenting logged in!");
    [self performSegueWithIdentifier:@"presentLoggedInVC" sender:self];
    
}
@end
