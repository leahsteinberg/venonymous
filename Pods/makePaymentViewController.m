//
//  makePaymentViewController.m
// 
//
//  Created by Leah Steinberg on 7/2/14.
//
//

#import "makePaymentViewController.h"
#import "VenonMakePayment.h"
#import <Venmo-iOS-SDK/Venmo.h>

@implementation makePaymentViewController

- (instancetype)init
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"MakePaymentVC"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.storyLabel.text = @"Send anonymous payment to:";
    //[storyText setOrigin:CGPointMake(50, 50)];
    
    self.targetLabel.textColor = [UIColor grayColor];
    self.targetLabel.text = self.paymentObject.targetDisplayName;
    self.textField.delegate = self;
}


#pragma mark - UITextfield Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sendMoneyButton:(UIButton *)sender {
    [Venmo sharedInstance].defaultTransactionMethod = VENTransactionMethodAPI;
    NSLog(@"pressed button!!!");
    NSString *beginningOfNote = [self.paymentObject.targetID stringByAppendingString:@"  "];
    NSString *noteToSend = [beginningOfNote stringByAppendingString:self.textField.text];
    NSString *anonymousID = @"2243385864";
    //VENTransactionAudience *audiencePrivate = VENTransactionAudiencePrivate;
    
    
    
   // NSString *noteWithID = [self.paymentObject.targetID stringByAppendingString:<#(NSString *)#>]
    
    [[Venmo sharedInstance] sendPaymentTo:anonymousID
                                            amount:1
                                     note:noteToSend
                                 audience:VENTransactionAudiencePrivate
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error){
                            if(success){
                                NSLog(@"was successful!!!");
                            }
                            else{
                                NSLog(@"payment failed");

                            }
                        }];
    
    
    // make payment using venmo sharedinstance
    // get info about whether or not it worked?
    // display some sort of confirmation thing
    // go back to the previous screen
    

}
@end
