//
//  CreatProfileViewController.h
//  final
//
//  Created by 谢菊萍 on 11/21/15.
//  Copyright © 2015 Priya Dilipkumar Poptani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccount.h"
#import "PatientProfile.h"
#import "Constants.h"

@interface CreatProfileViewController : UIViewController<UITextFieldDelegate>
{
    UserAccount *ua;
    PatientProfile *profile;
}

@property(strong, nonatomic)UserAccount *ua;
@property(strong, nonatomic)PatientProfile *profile;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
- (IBAction)btnDoneClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtLanguage;
@property (weak, nonatomic) IBOutlet UITextField *txtEnthnonym;
@property (weak, nonatomic) IBOutlet UITextField *txtEnthnity;
@property (weak, nonatomic) IBOutlet UITextField *txtFeet;
@property (weak, nonatomic) IBOutlet UITextField *txtInch;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (weak, nonatomic) IBOutlet UISwitch *swWorking;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpStartDate;
- (IBAction)swWorkingClicked:(id)sender;
@end
