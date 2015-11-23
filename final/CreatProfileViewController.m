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
@synthesize doctorList;
@synthesize selectedRow;

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
    self.doctorList = [[NSMutableArray alloc]init];
    self.profile.currentlyWorking = @"YES";
    
    NSDictionary *newData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.ua.userId],@"userid",self.ua.username,@"username",self.ua.password,nil];
    NSData * dataVal = [NSJSONSerialization dataWithJSONObject:newData options:kNilOptions error:nil];
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@doctorlist",Url];
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%ul",(unsigned)[dataVal length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:dataVal];
    
    NSHTTPURLResponse *response = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if ([response statusCode] >= 200 && [response statusCode] <= 300) {
        id docList = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        
        if (docList) {
            for (id object in docList) {
                NSString *fName = [object objectForKey:@"firstname"];
                NSString *lName = [object objectForKey:@"lastname"];
                if (fName && lName) {
                    NSString *name = [fName stringByAppendingString:lName];
                    [self.doctorList addObject:name];
                }
            }
        }
    }
}

//Pickerview delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger count = [self.doctorList count];
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.doctorList objectAtIndex:row];
}

//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [self.doctorList objectAtIndex:row];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
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
    
    self.profile.userId = self.ua.userId;
    self.profile.doctorId = self.selectedRow;
    NSInteger feet = [[_txtFeet text] integerValue];
    NSInteger inch = [[_txtInch text] integerValue];
    if (feet) {
        self.profile.feet = feet;
        self.profile.inches = inch;
    }else{
        [self alertStatus:@"Please enter data in all fields" :@"Invalid entry!" :0];
    }
    NSInteger weight = [[_txtWeight text] integerValue];
    if (weight) {
        self.profile.weight = weight;
    }else{
        [self alertStatus:@"Please enter data in all fields" :@"Invalid entry!" :0];
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
        NSDictionary *myprofiledictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                             profile.firstName,@"firstname",
                                             profile.lastName,@"lastname",
                                             profile.gender,@"gender",
                                             profile.language,@"language",
                                             profile.startDate,@"date",
                                             profile.enthnonym,@"enthnonym",
                                             profile.enthnicity,@"enthnicity",
                                             profile.currentlyWorking,@"currentlyWorking",
                                             [NSNumber numberWithInteger:profile.userId],@"userid",
                                             [NSNumber numberWithLong:profile.doctorId],@"doctorid",
                                             [NSNumber numberWithInteger:profile.feet],@"feet",
                                             [NSNumber numberWithInteger:profile.inches],@"inches",
                                             [NSNumber numberWithInteger:profile.weight],@"weight",
                                             nil];
        
        NSData *myprofiledata = [NSJSONSerialization dataWithJSONObject:myprofiledictionary options:kNilOptions error:nil];
        
        NSString *stringUrl = [NSString stringWithFormat:@"%@saveprofile",Url];
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
        
        [self performSegueWithIdentifier:@"profile_done" sender:self];
    }else{
        [self alertStatus:@"Please enter data in all fields" :@"Invalid entry!" :0];
    }
    
}

- (IBAction)swWorkingClicked:(id)sender {
    if ([self.profile.currentlyWorking isEqualToString:@"YES"]) {
        self.profile.currentlyWorking = @"NO";
    }else{
        self.profile.currentlyWorking = @"YES";
    }
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"profile_done"]){
        DecisionViewController *dvc= (DecisionViewController*)[segue destinationViewController];
        dvc.ua =self.ua;
    }
}

@end
