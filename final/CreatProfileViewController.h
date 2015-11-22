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

@interface CreatProfileViewController : UIViewController
{
    UserAccount *ua;
    PatientProfile *profile;
}

@property(strong, nonatomic)UserAccount *ua;
@property(strong, nonatomic)PatientProfile *profile;
@end
