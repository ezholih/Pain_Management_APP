//
//  EditProfileViewController.m
//  final
//
//  Created by apple on 5/15/15.
//  Copyright (c) 2015 Priya Dilipkumar Poptani. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Constants.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
@synthesize profile,lname,fname,gender;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    lname.text = profile.lastName;
    fname.text = profile.firstName;
    gender.text = profile.gender;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)Save:(id)sender {
    
    profile.firstName = [fname text];
    profile.lastName = [lname text];
    profile.gender = [gender text];
    
    // NSInteger success = 0;
    @try {
        
        if([[self.fname text] isEqualToString:@""] || [[self.lname text] isEqualToString:@""]
           || [[self.gender text] isEqualToString:@""]) {
            
            [self alertStatus:@"Please enter data in all fields" :@"Invalid entry!" :0];
            
        } else {
            
            
            NSDictionary *myprofiledictionary = [NSDictionary dictionaryWithObjectsAndKeys:profile.firstName,@"firstname",profile.lastName,@"lastname",profile.gender,@"gender",[NSNumber numberWithLong:profile.userId],@"userid",nil];
            
            NSData *myprofiledata = [NSJSONSerialization dataWithJSONObject:myprofiledictionary options:kNilOptions error:nil];
            
            NSString *stringUrl = [NSString stringWithFormat:@"%@editprofile",Url];
            NSURL *url = [NSURL URLWithString:stringUrl];
            
            //NSURL *profileUrl = [NSURL URLWithString:@"http://localhost:8080/finalproject/editprofile"];
            
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
            
            id<EditProfileViewControllerDelegate> del = self.delegate;
            if([del respondsToSelector:@selector(editProfileViewController:didChooseValue:)]){
                [del editProfileViewController:self didChooseValue:self.profile];
            }
            
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
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



@end
