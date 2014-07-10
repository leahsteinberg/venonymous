//
//  makePaymentViewController.h
//  Pods
//
//  Created by Leah Steinberg on 7/2/14.
//
//

#import <Foundation/Foundation.h>
#import "VenonMakePayment.h"

@interface makePaymentViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
- (IBAction)sendMoneyButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (strong, nonatomic) VenonMakePayment *paymentObject;

@end
