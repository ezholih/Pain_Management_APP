//
//  CreatProfileViewController.m
//  final
//
//  Created by 谢菊萍 on 11/21/15.
//  Copyright © 2015 Priya Dilipkumar Poptani. All rights reserved.
//

#import "CreatProfileViewController.h"

@implementation CreatProfileViewController
@synthesize ua;
@synthesize profile;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.profile = [[PatientProfile alloc]init];
    self.profile.currentlyWorking = @"YES";
}

//Handle Keyboard layout when in landscapte orientation.

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

//Create profile

- (IBAction)btnDoneClicked:(id)sender {
    
    NSInteger feet = [[_txtFeet text] integerValue];
    NSInteger inch = [[_txtInch text] integerValue];
    if (!feet) {
        self.profile.feet = feet;
        self.profile.inches = inch;
    }
    self.profile.firstName = [_txtFirstName text];
    self.profile.lastName = [_txtLastName text];
    self.profile.gender = [_txtGender text];
    self.profile.language = [_txtLanguage text];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *startDate = [_dpStartDate date];
    self.profile.startDate = [dateFormatter stringFromDate:startDate];
    self.profile.enthnonym = [_txtEnthnonym text];
    self.profile.enthnicity = [_txtEnthnity text];
    if ([self.profile validateProfile:self.profile]) {
        NSDictionary *myprofiledictionary = [NSDictionary dictionaryWithObjectsAndKeys:profile.firstName,@"firstname",
                                             profile.lastName,@"lastname",
                                             profile.gender,@"gender",
                                             [NSNumber numberWithLong:profile.userId],@"userid",
                                             profile.language,@"language",
                                             profile.startDate,@"date",
                                             profile.enthnonym,@"enthnonym",
                                             profile.enthnicity,@"enthnicity",
                                             profile.currentlyWorking,@"currentlyWorking",
                                             nil];
        
        NSData *myprofiledata = [NSJSONSerialization dataWithJSONObject:myprofiledictionary options:kNilOptions error:nil];
        
        NSString *stringUrl = [NSString stringWithFormat:@"%@editprofile",Url];
        NSURL *url = [NSURL URLWithString:stringUrl];
        
        NSMutableURLRequest *editProfileRequest = [NSMutableURLRequest requestWithURL:url];
        
        [editProfileRequest setHTTPMethod:@"POST"];
        [editProfileRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [editProfileRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [editProfileRequest setValue:[NSString stringWithFormat:@"%ul",(unsigned)[myprofiledata length]] forHTTPHeaderField:@"Content-length"];
        [editProfileRequest setHTTPBody:myprofiledata];
        
        NSURLResponse *response = nil;
        
        NSData *result = [NSURLConnection sendSynchronousRequest:editProfileRequest returningResponse:&response error:nil];
        
        NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",resultString);
    }else{
        [self alertStatus:@"Please enter data in all fields" :@"Invalid entry!" :0];
    }
    
}

- (IBAction)swWorkingClicked:(id)sender {
    self.profile.currentlyWorking = @"NO";
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

@end
