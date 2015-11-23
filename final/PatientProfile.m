//
//  PatientProfile.m
//  final
//
//  Created by Priya Dilipkumar Poptani on 5/2/15.
//  Copyright (c) 2015 Priya Dilipkumar Poptani. All rights reserved.
//

#import "PatientProfile.h"

@implementation PatientProfile
@synthesize userId,firstName,lastName,gender,startDate,healthCondition,isPrescribed,language,enthnicity,enthnonym,lastGradeSchool,currentlyWorking,feet,inches,weight,doctorId;

-(NSString *)description{
    return [NSString stringWithFormat:@"\n doctorId : %li, \nfirst Name: %@, \nsStart Date: %@ , \nGender: %@", (long)self.doctorId,self.firstName,self.startDate, self.gender];
}

-(BOOL)validateProfile:(PatientProfile *)profile
{
    PatientProfile *p = profile;
    if ([p.firstName isEqualToString:@""] || [p.lastName isEqualToString:@""]
          || [p.gender isEqualToString:@""] || [p.language isEqualToString:@""]
          || [p.enthnicity isEqualToString:@""] || [p.enthnonym isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}
@end
