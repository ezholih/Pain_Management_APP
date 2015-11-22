//
//  EditProfileViewController.h
//  final
//
//  Created by apple on 5/15/15.
//  Copyright (c) 2015 Priya Dilipkumar Poptani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientProfile.h"

@protocol EditProfileViewControllerDelegate;

@interface EditProfileViewController : UIViewController

@property (strong,nonatomic) PatientProfile *profile;
@property (weak, nonatomic) IBOutlet UITextField *fname;
@property (weak, nonatomic) IBOutlet UITextField *lname;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (nonatomic, weak) id<EditProfileViewControllerDelegate> delegate;

- (IBAction)Save:(id)sender;


@end
@protocol EditProfileViewControllerDelegate <NSObject>

-(void)editProfileViewController:(EditProfileViewController *)epvc didChooseValue:(PatientProfile *)profile;

@end