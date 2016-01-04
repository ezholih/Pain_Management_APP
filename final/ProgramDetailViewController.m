//
//  ProgramDetailViewController.m
//  final
//
//  Created by apple on 5/31/15.
//  Copyright (c) 2015 Priya Dilipkumar Poptani. All rights reserved.
//

#import "ProgramDetailViewController.h"
#import "ActionFeedback.h"
#import "Constants.h"
#import "AppDelegate.h"
@interface ProgramDetailViewController ()
{
    AppDelegate *mydelegate;
}
@end

@implementation ProgramDetailViewController
@synthesize data,ua;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mydelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.title =data.programName;
    self.pickerView.hidden = YES;
    self.clickToWatch.hidden = YES;
    self.done.hidden = YES;
    self.playVideoButton.hidden = YES;
    self.programName.text = data.programName;
    if (data.programDetails == NULL) {
        self.programDescription.text = data.programDetails;
    }else{
        self.programDescription.text = @"";
    }
    
    self.programDescription.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg18.jpg"]];
    self.programDescription.layer.borderWidth = 5.0f;
    self.programDescription.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.programDescription setScrollEnabled:YES];
    [self.programDescription setUserInteractionEnabled:YES];
    
    if(![data.programUrl isEqual:[NSNull null]] ){
        self.clickToWatch.hidden = NO;
        self.playVideoButton.hidden = NO;
        self.playVideoButton.layer.cornerRadius = 10;
    }
    
    self.pickerData = @[@"Satisfied",@"Normal",@"Not Satisfied"];
//    self.pickerView.dataSource = self;
//    self.pickerView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}

- (IBAction)playVideo:(id)sender {
    
    NSURL *url = [NSURL URLWithString:data.programUrl];
  
    moviePlayer = [[MPMoviePlayerViewController
                    alloc]initWithContentURL:url];
    [self presentViewController:moviePlayer animated:NO completion:nil];
    self.pickerView.hidden = NO;
    self.done.hidden = NO;
}
- (IBAction)done:(id)sender {
    //NSString *data = [self.pickerData objectAtIndex: selectedRow];
   // NSLog(data);
    [self converttojson];
    
    id<programViewControllerDelegate> del = self.delegate;
    if([del respondsToSelector:@selector(programViewController:didChooseValue:)]){
        [del programViewController:self didChooseValue:self.ua];
    }
}

-(void)converttojson{
    
    NSString *currentDate;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    currentDate = [dateFormatter stringFromDate:now];
    
    ActionFeedback *af =[[ActionFeedback alloc]init];
    af.actionId = [NSString stringWithFormat:@"%li%@",(long)ua.userId,currentDate];
    af.programId = data.programId;
    af.userId = ua.userId;
    af.answerValue =[self.pickerData objectAtIndex: selectedRow];

    
    
    NSMutableDictionary *obj = [[NSMutableDictionary alloc]init];
    
    [obj setObject:af.actionId forKey:@"actionid"];
    [obj setObject:[NSNumber numberWithInteger:af.programId] forKey:@"programid"];
    [obj setObject:[NSNumber numberWithInteger:af.userId] forKey:@"userid"];
    [obj setObject:af.answerValue forKey:@"answervalue"];

    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:nil];
   // NSString *jsonString = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@actionfeedback",Url];
    NSURL *url = [NSURL URLWithString:stringUrl];
    
  //  NSURL *url = [NSURL URLWithString:@"http://localhost:8080/finalproject/actionfeedback"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%ul",(unsigned)[jsonData2 length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:jsonData2];

    NSLog(@"JSON summary : %@",[[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding]);
    NSHTTPURLResponse *response = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *responseData = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"Response ==> %@", responseData);

    
}

@end
