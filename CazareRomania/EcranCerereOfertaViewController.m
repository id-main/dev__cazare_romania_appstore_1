//
//  EcranCerereOfertaViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 14/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranCerereOfertaViewController.h"
#import "DropDownTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "StartViewController.h"
#import "AppDelegate.h"
#define ROOMS 0
#define ADULTS 1
#define CHILDREAN 2
#define CURRENCY 3
#define COSTTYPE 4
#define STARTDATE 5
#define ENDDATE 6

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface EcranCerereOfertaViewController ()

@end

@implementation EcranCerereOfertaViewController

@synthesize selectAdultsLabel,selectAdultsView,selectChildreanLabel,selectChildreanView,selectDateView,selectRoomsAndPeopleView,selectRoomsLabel,selectRoomsView,startDateLabel,otherTextView,otherView,totalCost,touristMail,touristName,touristPhone,touristView,backButton,cancelButton,budgetView,flexibleDates, currencyLabel, costTypeLabel,currencyView,costTypeVIew,mainScrollView,warningMessage, costLabelParentView, adultsLabelParentView, childreanLabelParentView, roomsLabelParentView,startDatePicker,startDatePickerView,cancelStartDate, chooseStartDate, endDatePicker, endDateLabel,endDatePickerView, hideView, startDateParentView, endDateParentView, dropDownScrollView, dropDownTableVIew,dropDownView,sendButton,dropDownLabel,switchBtn, selectRoomsTitleLabel, dateSep3, dateSep2, dateSep1, dateSep4,dateSep5, startLabel, endLabel, flexibleLabel, roomsLabel, adultsLabel, childreanLabel, budget, sepRoom, sepAdults, sepChildrean, otherReqLabel, sepSelectCurrency, sepSelectGroup, greenBorder, screenTitle,myJson;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
        // ne asiguram ca functioneaza actiunea de pe status bar
    
    [mainScrollView setScrollsToTop:YES];
    [dropDownScrollView setScrollsToTop:NO];
    [dropDownTableVIew setScrollsToTop:NO];
    [otherTextView setScrollsToTop:NO];
    [warningMessage setScrollsToTop:NO];
    
    
    cancelButton.layer.cornerRadius = 5.0;
    cancelButton.layer.borderWidth = 1.0;
    cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelButton.layer.masksToBounds = YES;
    
    if ([self respondsToSelector:@selector(prefersStatusBarHidden)]) {
        [self prefersStatusBarHidden];
    }
    else{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    selectedRows = [[NSMutableArray alloc] initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM yyyy"];
    
    months = @[@"Ianuarie",@"Februarie",@"Martie",@"Aprilie",@"Mai",@"Iunie",@"Iulie",@"August",@"Septembrie",@"Octombrie",@"Noiembrie",@"Decembrie"];
    
    weekDays = @[@"Duminica", @"Luni", @"Marti", @"Miercuri", @"Joi", @"Vineri", @"Sambata"];
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int currentWeekday = [weekdayComponents weekday]; //[1;7] ... 1 is sunday, 7 is saturday in gregorian calendar
    
    
    
    
    //ComNSLog(@"my current weekDay---%d", currentWeekday);
    
    NSDateComponents *compStart = [[NSDateComponents alloc] init];
    NSDateComponents *compEnd = [[NSDateComponents alloc] init];
    
    if(currentWeekday >=2 && currentWeekday <= 5){
        [compEnd setDay:8- currentWeekday];
        [compStart setDay:6 - currentWeekday];
    }
    else{
        if(currentWeekday >= 6 && currentWeekday <= 7){
            [compEnd setDay:8- currentWeekday];
            [compStart setDay:0];
        }
        else{
            if(currentWeekday == 1){
                [compEnd setDay:3-currentWeekday];
                [compStart setDay:0];
            }
        }
    }
    
    
    
    //ComNSLog(@"next friday---%@",[[NSCalendar currentCalendar] dateByAddingComponents:compStart toDate:[NSDate date] options:0]);
    
    startDate = [[NSCalendar currentCalendar] dateByAddingComponents:compStart toDate:[NSDate date] options:0];
    
    //ComNSLog(@"comp start---%d",compStart.day);
    if([startDate compare:[NSDate date]] == NSOrderedAscending && compStart.day != 0){
        [compStart setDay:compStart.day + 7];
        startDate = [[NSCalendar currentCalendar] dateByAddingComponents:compStart toDate:[NSDate date] options:0];
    }
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 30;
    
    NSDate * limitDate = [NSDate date];
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    limitDate = [theCalendar dateByAddingComponents:dayComponent toDate:limitDate options:0];
    
    
    
    [startDatePicker setMinimumDate:[NSDate date]];
    [startDatePicker setMaximumDate:limitDate];
    [startDatePicker setDate:startDate];
    startDateAux = startDate;
    
    
    NSDate * endDate = [[NSCalendar currentCalendar] dateByAddingComponents:compEnd toDate:[NSDate date] options:0];
    
    if([endDate compare:[NSDate date]] == NSOrderedAscending || [endDate compare:startDate] == NSOrderedAscending){
        [compEnd setDay:compEnd.day + 7];
        endDate = [[NSCalendar currentCalendar] dateByAddingComponents:compEnd toDate:[NSDate date] options:0];
    }
    
    NSDate *endLimitDate = startDatePicker.date;
    NSDate *endLowLimitDate = startDatePicker.date;
    
    dayComponent.day = 15;
    endLimitDate = [theCalendar dateByAddingComponents:dayComponent toDate:endLimitDate options:0];
    
    dayComponent.day = 1;
    endLowLimitDate = [theCalendar dateByAddingComponents:dayComponent toDate:endLowLimitDate options:0];
    
    //ComNSLog(@"end picker minimum---%@,%@", [formatter stringFromDate:endLowLimitDate],[formatter stringFromDate:endDate]);
    
    [endDatePicker setMinimumDate:endLowLimitDate];
    [endDatePicker setMaximumDate:endLimitDate];
    [endDatePicker setDate:endDate];
    endDateAux = endDate;
    
    //start date
    

    
    NSArray * tempStringArray = [[formatter stringFromDate:startDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * tempMonth = months[[tempStringArray[1] intValue]-1];
    
    NSString *startDateString = [NSString stringWithFormat:@" %@ %@ %@",tempStringArray[0], tempMonth, tempStringArray[2]];
    
//    NSArray * startStringArray = [[formatter stringFromDate:startDatePicker.date] componentsSeparatedByString:@" "];
//    
//    NSString * startMonth = months[[startStringArray[1] intValue]-1];
//    
//    NSString *startDateString = [NSString stringWithFormat:@"%@ %@ %@",startStringArray[0], startMonth, startStringArray[2]];
    
    //end date
    

    
    NSArray * tempStringArrayEnd = [[formatter stringFromDate:endDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * tempMonthEnd = months[[tempStringArray[1] intValue]-1];
    
    NSString *endDateString = [NSString stringWithFormat:@" %@ %@ %@",tempStringArrayEnd[0], tempMonthEnd, tempStringArrayEnd[2]];
//    NSArray * endStringArray = [[formatter stringFromDate:endDatePicker.date] componentsSeparatedByString:@" "];
//    
//    NSString * endMonth = months[[endStringArray[1] intValue]-1];
//    
//    NSString *endDateString = [NSString stringWithFormat:@"%@ %@ %@",endStringArray[0], endMonth, endStringArray[2]];
    
    //ComNSLog(@"end date string---%@",endDateString);
    
    
    
    [startDateLabel setText:startDateString];
    [endDateLabel setText:endDateString];
    
    
    startDates = [[NSMutableArray alloc] init];
    endDates = [[NSMutableArray alloc] init];
    
    NSDateComponents *components = [theCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date] toDate:startDate options:0];
    
    [selectedRows setObject:[NSNumber numberWithInteger:components.day +1] atIndexedSubscript:STARTDATE];
    
    for(int i=0; i<31; i++){
        NSDate *tempDate = [NSDate date];
        
        dayComponent.day = i;
        tempDate = [theCalendar dateByAddingComponents:dayComponent toDate:tempDate options:0];
  
        NSDateComponents *comps = [theCalendar components:NSWeekdayCalendarUnit fromDate:tempDate];
        int weekday = [comps weekday];
        
        NSArray * tempStringArray = [[formatter stringFromDate:tempDate] componentsSeparatedByString:@" "];
        
        NSString * tempMonth = months[[tempStringArray[1] intValue]-1];
        
        NSString *tempDateString = [NSString stringWithFormat:@"%@, %@ %@ %@",weekDays[weekday-1],tempStringArray[0], tempMonth, tempStringArray[2]];
        
        [startDates addObject:tempDateString];
    }
    
    for(int i=1; i<45; i++){
        NSDate *tempDate = [NSDate date];
        
        dayComponent.day = i;
        tempDate = [theCalendar dateByAddingComponents:dayComponent toDate:tempDate options:0];
        
        NSDateComponents *comps = [theCalendar components:NSWeekdayCalendarUnit fromDate:tempDate];
        int weekday = [comps weekday];
        
        NSArray * tempStringArray = [[formatter stringFromDate:tempDate] componentsSeparatedByString:@" "];
        
        NSString * tempMonth = months[[tempStringArray[1] intValue]-1];
        
        NSString *tempDateString = [NSString stringWithFormat:@"%@, %@ %@ %@",weekDays[weekday-1],tempStringArray[0], tempMonth, tempStringArray[2]];
        
        
        [endDates addObject:tempDateString];
    }
    
    dayComponent.day =1;
    
    NSDateComponents *endcomponents = [theCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date] toDate:[theCalendar dateByAddingComponents:dayComponent toDate:startDate options:0] options:0];
    
    [selectedRows setObject:[NSNumber numberWithInteger:endcomponents.day +1] atIndexedSubscript:ENDDATE];
    

    


    //ComNSLog(@"ids pensiuni:    %@",idsPensiuni);
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) NSStringisValidName:(NSString *)checkString{
    NSCharacterSet *alphaSet = [NSCharacterSet letterCharacterSet];
    NSString *temp = [[checkString stringByTrimmingCharactersInSet:alphaSet] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    BOOL valid = [[temp stringByReplacingOccurrencesOfString:@"-" withString:@"" ] isEqualToString:@""];
    return valid;
}

-(BOOL) NSStringIsValidPhone:(NSString *)checkString{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";;
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:checkString];
    return matches;
}


-(void)viewWillAppear:(BOOL)animated{
    


    
    [dropDownTableVIew setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * name = [defaults objectForKey:@"Nume.Cazare.ro"];
    NSString * mail = [defaults objectForKey:@"Mail.Cazare.ro"];
    NSString * phone = [defaults objectForKey:@"Phone.Cazare.ro"];
    
    if(name.length > 0){
        [touristName setText:name];
    }
    if(phone.length > 0){
        [touristPhone setText:phone];
    }
    if(mail.length > 0){
        [touristMail setText:mail];
    }
    
    [screenTitle setFont:[UIFont fontWithName:@"OpenSans" size:21.5f]];
    
    [greenBorder setBackgroundColor:UIColorFromRGB(0x94af39)];
    [backButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    

    [startDateLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [startDateLabel setTextColor:UIColorFromRGB(0xcb314b)];
    
    [endDateLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [endDateLabel setTextColor:UIColorFromRGB(0xcb314b)];
    
    [warningMessage setFont:[UIFont fontWithName:@"OpenSans" size:12.5f]];
    [warningMessage setTextColor:UIColorFromRGB(0xcb314b)];
    
    [selectRoomsTitleLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [selectRoomsTitleLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [otherReqLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [otherReqLabel setTextColor:UIColorFromRGB(0x333333)];
    
    
    [dateSep1 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [dateSep2 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [dateSep3 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [dateSep4 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [dateSep5 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [sepRoom setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [sepAdults setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [sepChildrean setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [sepSelectGroup setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [sepSelectCurrency setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    
    
    
    CGRect sepRoomsFrame = sepRoom.frame;
    [sepRoom setFrame:CGRectMake(sepRoomsFrame.origin.x + 0.5, sepRoomsFrame.origin.y ,0.5, sepRoomsFrame.size.height)];
    
    CGRect sepAdultsFrame = sepAdults.frame;
    [sepAdults setFrame:CGRectMake(sepAdultsFrame.origin.x+0.5, sepAdultsFrame.origin.y, 0.5, sepAdultsFrame.size.height)];
    
    CGRect sepChildFrame = sepChildrean.frame;
    [sepChildrean setFrame:CGRectMake(sepChildFrame.origin.x+0.5, sepChildFrame.origin.y, 0.5, sepChildFrame.size.height)];
    
    
    CGRect sepGroupFrame = sepSelectGroup.frame;
    [sepSelectGroup setFrame:CGRectMake(sepGroupFrame.origin.x+0.5, sepGroupFrame.origin.y,0.5, sepGroupFrame.size.height)];
    
    CGRect sepCurrencyFrame = sepSelectCurrency.frame;
    [sepSelectCurrency setFrame:CGRectMake(sepCurrencyFrame.origin.x+0.5, sepCurrencyFrame.origin.y,0.5, sepCurrencyFrame.size.height)];
    
    
    CGRect sepDate1Frame = dateSep1.frame;
    [dateSep1 setFrame:CGRectMake(sepDate1Frame.origin.x, sepDate1Frame.origin.y,sepDate1Frame.size.width ,0.5)];
    
    CGRect sepDate2Frame = dateSep2.frame;
    [dateSep2 setFrame:CGRectMake(sepDate2Frame.origin.x, sepDate2Frame.origin.y +0.5,sepDate2Frame.size.width ,0.5)];
    
    CGRect sepDate3Frame = dateSep3.frame;
    [dateSep3 setFrame:CGRectMake(sepDate3Frame.origin.x, sepDate3Frame.origin.y +0.5,sepDate3Frame.size.width ,0.5)];
    
    CGRect sepDate4Frame = dateSep4.frame;
    [dateSep4 setFrame:CGRectMake(sepDate4Frame.origin.x, sepDate4Frame.origin.y +0.5,sepDate4Frame.size.width ,0.5)];
    
    CGRect sepDate5Frame = dateSep5.frame;
    [dateSep5 setFrame:CGRectMake(sepDate5Frame.origin.x, sepDate5Frame.origin.y +0.5,sepDate5Frame.size.width ,0.5)];
    
    
     dateSep1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    dateSep2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    dateSep3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    dateSep4.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    dateSep5.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;


    
    [startLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [startLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [endLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [endLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [dropDownLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [dropDownLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [flexibleLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [flexibleLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [adultsLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [adultsLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [childreanLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [childreanLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [budget setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [budget setTextColor:UIColorFromRGB(0x333333)];
    
    [roomsLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [roomsLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [selectRoomsLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [selectRoomsLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [selectChildreanLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [selectChildreanLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [selectAdultsLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [selectAdultsLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [costTypeLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [costTypeLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [currencyLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [currencyLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [totalCost setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [totalCost setTextColor:UIColorFromRGB(0x666666)];
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [mainScrollView setBounces:YES];
    
   [mainScrollView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:240/255.0 blue:197/255.0 alpha:1.0]];
    
  //  [mainScrollView setBackgroundColor:[UIColor redColor]];
    
    [touristView setFrame:CGRectMake(touristView.frame.origin.x, warningMessage.frame.origin.y+ warningMessage.frame.size.height, self.view.bounds.size.width, touristView.frame.size.height)];
    
    [touristName setBorderStyle:UITextBorderStyleNone];
    touristName.layer.cornerRadius = 5.0;
    touristName.layer.borderWidth = 0.5;
    touristName.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    touristName.layer.masksToBounds = YES;
    
    [touristMail setBorderStyle:UITextBorderStyleNone];
    touristMail.layer.cornerRadius = 5.0;
    touristMail.layer.borderWidth = 0.5;
    touristMail.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    touristMail.layer.masksToBounds = YES;
    
    [touristPhone setBorderStyle:UITextBorderStyleNone];
    touristPhone.layer.cornerRadius = 5.0;
    touristPhone.layer.borderWidth = 0.5;
    touristPhone.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    touristPhone.layer.masksToBounds = YES;
    
    
    UIFont* italicFont = [UIFont fontWithName:@"OpenSansLight-Italic" size:17.5f];
    
    
    [touristName setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    [touristMail setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    [touristPhone setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    [totalCost setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    
    touristName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    touristMail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    touristPhone.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    totalCost.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [touristPhone setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [touristPhone setTextColor:UIColorFromRGB(0x666666)];
    
    [totalCost setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [totalCost setTextColor:UIColorFromRGB(0x666666)];
    
    [touristName setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [touristName setTextColor:UIColorFromRGB(0x666666)];
    
    [touristMail setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [touristMail setTextColor:UIColorFromRGB(0x666666)];
    
    [mainScrollView addSubview:touristView];
    
    [touristView setNeedsLayout];
    [touristView setNeedsDisplay];
    
    [selectDateView setFrame:CGRectMake(selectDateView.frame.origin.x, touristView.frame.origin.y + touristView.frame.size.height, self.view.bounds.size.width, selectDateView.frame.size.height)];
    
    int xPoz = (flexibleDates.frame.origin.x + flexibleDates.frame.size.width) - self.view.bounds.size.width;
    
    [flexibleDates setFrame:CGRectMake(flexibleDates.frame.origin.x - xPoz, flexibleDates.frame.origin.y, flexibleDates.frame.size.width, flexibleDates.frame.size.height)];
    
//    [flexibleDates setThumbTintColor:[UIColor greenColor]];
//    [flexibleDates setBackgroundColor:[UIColor whiteColor]];
    //++++CUSTOM SWITCH
    switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchBtn addTarget:self
               action:@selector(SWITCHCONOFF)
     forControlEvents:UIControlEventTouchUpInside];
   switchBtn.frame = CGRectMake(selectDateView.frame.origin.x + selectDateView.frame.size.width -60, selectDateView.frame.origin.y + selectDateView.frame.size.height -35, 52.0, 30.0);
    //    [view addSubview:button];
    UIImage* swOff = [UIImage imageNamed:@"switchcoff.png"];
    UIImage* swOn = [UIImage imageNamed:@"switchon.png"];
    [switchBtn setBackgroundImage:swOn forState:UIControlStateSelected];
    [switchBtn setBackgroundImage:swOff forState:UIControlStateNormal];
    switchBtn.selected =YES;
    [mainScrollView addSubview:selectDateView];
    [mainScrollView addSubview:switchBtn];
//+++++
    [selectRoomsAndPeopleView setFrame:CGRectMake(selectRoomsAndPeopleView.frame.origin.x, selectDateView.frame.origin.y + selectDateView.frame.size.height, self.view.bounds.size.width, selectRoomsAndPeopleView.frame.size.height)];
    
    
    roomsLabelParentView.layer.cornerRadius = 5.0;
    roomsLabelParentView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    roomsLabelParentView.layer.borderWidth = 0.5;
    roomsLabelParentView.layer.masksToBounds = YES;
    
    adultsLabelParentView.layer.cornerRadius = 5.0;
    adultsLabelParentView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    adultsLabelParentView.layer.borderWidth = 0.5;
    adultsLabelParentView.layer.masksToBounds = YES;
    
    childreanLabelParentView.layer.cornerRadius = 5.0;
    childreanLabelParentView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    childreanLabelParentView.layer.borderWidth = 0.5;
    childreanLabelParentView.layer.masksToBounds = YES;
    

    [mainScrollView addSubview:selectRoomsAndPeopleView];
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, selectRoomsAndPeopleView.frame.origin.y + selectRoomsAndPeopleView.frame.size.height +25)];
    
    [budgetView setFrame:CGRectMake(budgetView.frame.origin.x, selectRoomsAndPeopleView.frame.size.height + selectRoomsAndPeopleView.frame.origin.y, self.view.bounds.size.width, budgetView.frame.size.height)];
    
    [totalCost setBorderStyle:UITextBorderStyleNone];
    totalCost.layer.cornerRadius = 5.0;
    totalCost.layer.borderWidth = 0.5;
    totalCost.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    totalCost.layer.masksToBounds = YES;
    
    [totalCost setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    
    totalCost.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    currencyView.layer.cornerRadius = 5.0;
    currencyView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    currencyView.layer.borderWidth = 0.5;
    currencyView.layer.masksToBounds = YES;
    
    costTypeVIew.layer.cornerRadius = 5.0;
    costTypeVIew.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    costTypeVIew.layer.borderWidth = 0.5;
    costTypeVIew.layer.masksToBounds = YES;
    
    [mainScrollView addSubview:budgetView];
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, budgetView.frame.origin.y + budgetView.frame.size.height + 25)];
    
    [otherView setFrame:CGRectMake(otherView.frame.origin.x, budgetView.frame.origin.y + budgetView.frame.size.height, self.view.bounds.size.width, otherView.frame.size.height)];
    
    otherTextView.layer.cornerRadius = 5.0;
    otherTextView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    otherTextView.layer.borderWidth = 0.5;
    otherTextView.layer.masksToBounds = YES;
    [otherTextView setScrollEnabled:NO];
    
    [mainScrollView addSubview:otherView];
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, otherView.frame.origin.y + otherView.frame.size.height+ 25)];
    

//    int xPos1 = (self.view.bounds.size.width - sendButton.frame.size.width) /2;
//    
//        //ComNSLog(@"self bounds---%@,%@,%d", NSStringFromCGRect(self.view.bounds),NSStringFromCGRect(sendButton.frame),xPos1);
//    [sendButton setFrame:CGRectMake(xPos1, otherView.frame.origin.y + otherView.frame.size.height + 25, sendButton.frame.size.width, sendButton.frame.size.height)];
    
    [mainScrollView addSubview:sendButton];
    
    
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        int xPos1 = ([[UIScreen mainScreen] bounds].size.width - sendButton.frame.size.width) /2;
        
        [sendButton setFrame:CGRectMake(xPos1, otherView.frame.origin.y + otherView.frame.size.height + 25, sendButton.frame.size.width, sendButton.frame.size.height)];
        
        if([[UIScreen mainScreen] bounds].size.height > 480){

            
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height+ 25)];
        }
        else{
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height+ 25)];
        }
        
        int height = [self sizeOfText:warningMessage.text widthOfTextView:warningMessage.frame.size.width withFont:[UIFont fontWithName:@"OpenSans" size:12.5f]].height;
        CGRect warningRect= warningMessage.frame;
        warningRect.size.height = height +5;
        [warningMessage setFrame:warningRect];
        [self moveForms];
    }
    else{
        int xPos1 = ([[UIScreen mainScreen] bounds].size.height - sendButton.frame.size.width) /2;
        
        [sendButton setFrame:CGRectMake(xPos1, otherView.frame.origin.y + otherView.frame.size.height + 25, sendButton.frame.size.width, sendButton.frame.size.height)];
       [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height+ 25)];
        int height = [self sizeOfText:warningMessage.text widthOfTextView:warningMessage.frame.size.width withFont:[UIFont fontWithName:@"OpenSans" size:12.5f]].height;
        CGRect warningRect= warningMessage.frame;
        warningRect.size.height = height +5;
        [warningMessage setFrame:warningRect];
        [self moveForms];
    }

    
    

    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
    minimumSize = otherTextView.frame.size;
    
    [mainScrollView bringSubviewToFront:hideView];
    
    
    // adauga recognizer pentru schimbat data
    
    UITapGestureRecognizer * fromrecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectStartDate:)];
    UITapGestureRecognizer *untilrecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEndDate:)];
    
    [startDateParentView addGestureRecognizer:fromrecogn];
    [endDateParentView addGestureRecognizer:untilrecogn];
    
    int stX, stY;
    stX = (self.view.frame.size.width - startDatePickerView.frame.size.width) /2;
    stY = (self.view.frame.size.height - startDatePickerView.frame.size.height) /2;
    
    [startDatePickerView setFrame:CGRectMake(stX, stY, startDatePickerView.frame.size.width, startDatePickerView.frame.size.height)];
    
    int endX, endY;
    endX = (self.view.frame.size.width - endDatePickerView.frame.size.width) /2;
    endY = (self.view.frame.size.height - endDatePickerView.frame.size.height) /2;
    
    [endDatePickerView setFrame:CGRectMake(endX, endY, endDatePickerView.frame.size.width, endDatePickerView.frame.size.height)];
    
    [self.view addSubview:startDatePickerView];
    [self.view addSubview:endDatePickerView];
    [startDatePickerView setHidden:YES];
    [endDatePickerView setHidden:YES];
    
//    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    //ComNSLog(@"app cost_type:  %@",appDelGlobal.ListaFiltreServer[@"results"][@"tipSuma"]);
    
    adults= @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    childrean = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    currency = @[@"Lei",@"Euro"];
    cost_type = @[@"de persoana",@"intreaga unitate",@"tot grupul"];
    rooms = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    

    
    [self.view addSubview:dropDownView];
    [self.view bringSubviewToFront:dropDownView];
    
    UIView * separatorView;
    for(UIView * mView in dropDownView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(dropDownLabel.frame),dropDownTableVIew.frame.size.width, 0.5)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorView setTag:666];
    
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;

    [dropDownView addSubview:separatorView];
    
    UITapGestureRecognizer * adultsRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownActionAdults:)];
    UITapGestureRecognizer * childreanRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownActionChildrean:)];
    UITapGestureRecognizer * currencyRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownActionCurrency:)];
    UITapGestureRecognizer * costTypeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownActionCostType:)];
    UITapGestureRecognizer *roomsGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownActionRooms:)];
    
    [selectAdultsView addGestureRecognizer:adultsRecognizer];
    [selectChildreanView addGestureRecognizer:childreanRecognizer];
    [currencyView addGestureRecognizer:currencyRecognizer];
    [costTypeVIew addGestureRecognizer:costTypeRecognizer];
    [selectRoomsView addGestureRecognizer:roomsGestureRecognizer];
    

    
    
    int xPos, yPos;
    xPos = 20;//(self.view.bounds.size.width - 250) /2;
    yPos = (self.view.bounds.size.height - dropDownView.frame.size.height) /2;
    
    [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
    


    
    [dropDownView setHidden:YES];
    
    
    
    otherTextView.contentInset = UIEdgeInsetsZero;
    otherTextView.showsHorizontalScrollIndicator = NO;
    otherTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    
    [mainScrollView setNeedsLayout];
    [mainScrollView setNeedsDisplay];
    
    UITapGestureRecognizer * recogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDown:)];
    recogn.numberOfTapsRequired = 1;
    [hideView addGestureRecognizer:recogn];
    
    
}

-(void)hideDropDown:(UITapGestureRecognizer *)recogn{
    [dropDownView setHidden:YES];
    [hideView setHidden:YES];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(fromInterfaceOrientation ==  UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        if([[UIScreen mainScreen] bounds].size.height > 480){
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height+ 25)];
              switchBtn.frame = CGRectMake(selectDateView.frame.origin.x + selectDateView.frame.size.width -60, selectDateView.frame.origin.y + selectDateView.frame.size.height -35, 52.0, 30.0);
        }
        else{
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height+ 25)];
        }
        int xPos1 = (self.view.frame.size.width - sendButton.frame.size.width) /2;
        //ComNSLog(@"xpos:   %d,%f",xPos1,self.view.frame.size.width);
        [sendButton setFrame:CGRectMake(xPos1, otherView.frame.origin.y + otherView.frame.size.height + 25, sendButton.frame.size.width, sendButton.frame.size.height)];
          switchBtn.frame = CGRectMake(selectDateView.frame.origin.x + selectDateView.frame.size.width -60, selectDateView.frame.origin.y + selectDateView.frame.size.height -35, 52.0, 30.0);
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height+ 25)];
        int xPos, yPos;
        xPos = 20;//(self.view.bounds.size.width - 250) /2;
        yPos = ([[UIScreen mainScreen] bounds].size.height - dropDownView.frame.size.height) /2;
        
        [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
        int height = [self sizeOfText:warningMessage.text widthOfTextView:warningMessage.frame.size.width withFont:[UIFont fontWithName:@"OpenSans" size:12.5f]].height;
        CGRect warningRect= warningMessage.frame;
        warningRect.size.height = height +5;
        [warningMessage setFrame:warningRect];
        [self moveForms];
        
    }
    else{
        int xPos1 = (self.view.frame.size.width - sendButton.frame.size.width) /2;
        //ComNSLog(@"x position---%d,%f,%f",xPos1,self.view.frame.size.width,sendButton.frame.size.width);
        [sendButton setFrame:CGRectMake(xPos1, otherView.frame.origin.y + otherView.frame.size.height + 25, sendButton.frame.size.width, sendButton.frame.size.height)];
          switchBtn.frame = CGRectMake(selectDateView.frame.origin.x + selectDateView.frame.size.width -60, selectDateView.frame.origin.y + selectDateView.frame.size.height -35, 52.0, 30.0);
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height+ 25)];
        int xPos, yPos;
        xPos = 20;//(self.view.bounds.size.width - 250) /2;
        yPos = (self.view.bounds.size.height - dropDownView.frame.size.height) /2;
        
        [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
        int height = [self sizeOfText:warningMessage.text widthOfTextView:warningMessage.frame.size.width withFont:[UIFont fontWithName:@"OpenSans" size:12.5f]].height;
        CGRect warningRect= warningMessage.frame;
        warningRect.size.height = height +5;
        [warningMessage setFrame:warningRect];
        [self moveForms];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)dropDownActionsStartDate:(UITapGestureRecognizer *)recognizer{
    [self calculateStartDate];
}

-(void)dropDownActionRooms:(UITapGestureRecognizer *)recognizer{
    [dropDownLabel setText:@"Numar camere:"];
    [dropDownView setHidden:NO];
    [hideView setHidden:NO];
    [dropDownTableVIew setTag:ROOMS];
    dataArray = rooms;
    [dropDownTableVIew setFrame:CGRectMake(dropDownTableVIew.frame.origin.x,dropDownTableVIew.frame.origin.y , dropDownTableVIew.frame.size.width, 49 * [dataArray count] + dropDownTableVIew.frame.origin.y)];
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableVIew.frame.size.height + dropDownTableVIew.frame.origin.y + 49)];
    [dropDownTableVIew reloadData];
}

-(void)dropDownActionAdults:(UITapGestureRecognizer *)recognizer{
    [dropDownLabel setText:@"Adulti"];
    [dropDownView setHidden:NO];
    [hideView setHidden:NO];
    [dropDownTableVIew setTag:ADULTS];
    dataArray = adults;
    [dropDownTableVIew setFrame:CGRectMake(dropDownTableVIew.frame.origin.x,dropDownTableVIew.frame.origin.y , dropDownTableVIew.frame.size.width, 49 * [dataArray count] + dropDownTableVIew.frame.origin.y)];
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableVIew.frame.size.height + dropDownTableVIew.frame.origin.y + 49)];
    [dropDownTableVIew reloadData];
}
-(void)dropDownActionChildrean:(UITapGestureRecognizer *)recognizer{
    [dropDownLabel setText:@"Copii"];
    [dropDownView setHidden:NO];
    [hideView setHidden:NO];
    dataArray = childrean;
    [dropDownTableVIew setFrame:CGRectMake(dropDownTableVIew.frame.origin.x,dropDownTableVIew.frame.origin.y , dropDownTableVIew.frame.size.width, 49 * [dataArray count] + dropDownTableVIew.frame.origin.y)];
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableVIew.frame.size.height + dropDownTableVIew.frame.origin.y + 49)];
    [dropDownTableVIew setTag:CHILDREAN];
    [dropDownTableVIew reloadData];
}
-(void)dropDownActionCurrency:(UITapGestureRecognizer *)recognizer{
    [dropDownLabel setText:@"Moneda"];
    [dropDownView setHidden:NO];
    [hideView setHidden:NO];
    dataArray = currency;
    [dropDownTableVIew setFrame:CGRectMake(dropDownTableVIew.frame.origin.x,dropDownTableVIew.frame.origin.y , dropDownTableVIew.frame.size.width, 49 * [dataArray count] + dropDownTableVIew.frame.origin.y)];
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableVIew.frame.size.height + dropDownTableVIew.frame.origin.y + 49)];
    [dropDownTableVIew setTag:CURRENCY];
    [dropDownTableVIew reloadData];
}
-(void)dropDownActionCostType:(UITapGestureRecognizer *)recognizer{
    [dropDownLabel setText:@"Tip tarif"];
    [dropDownView setHidden:NO];
    [hideView setHidden:NO];
    dataArray = cost_type;
    [dropDownTableVIew setFrame:CGRectMake(dropDownTableVIew.frame.origin.x,dropDownTableVIew.frame.origin.y , dropDownTableVIew.frame.size.width, 49 * [dataArray count] + dropDownTableVIew.frame.origin.y)];
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableVIew.frame.size.height + dropDownTableVIew.frame.origin.y + 49)];
    [dropDownTableVIew setTag:COSTTYPE];
    [dropDownTableVIew reloadData];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DropDownTableViewCell";
    DropDownTableViewCell *cell = (DropDownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownTableViewCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (DropDownTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if([selectedRows[tableView.tag] intValue] == indexPath.row){
        [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
        [cell.checkImage setHidden:NO];
    }
    else{
        [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
        [cell.checkImage setHidden:YES];
    }
    
    [cell.noOfRooms setText:dataArray[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView * separatorView;
    for(UIView * mView in cell.contentView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,49 - 0.5 ,tableView.frame.size.width, 0.5)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorView setTag:666];
    
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:separatorView];
    
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        for(int i = 0; i< [tableView numberOfRowsInSection:0]; i++){
            if(i != indexPath.row){
                DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
                [cell.checkImage setHidden:YES];
            }
        }
    
    [selectedRows setObject:[NSNumber numberWithInt:indexPath.row] atIndexedSubscript:tableView.tag];
    
    [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
    [cell.checkImage setHidden:NO];
    
    [dropDownView setHidden:YES];
    auxnumber = indexPath.row;
    [self dropDownSelectFunctionCateg:tableView.tag];

}


-(void)dropDownSelectFunctionCateg:(int)idCateg{
    
    switch (idCateg) {
        case ADULTS:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            [selectAdultsLabel setText:[NSString stringWithFormat:@"%d",auxnumber+1]];
            break;
        }
        case CHILDREAN:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            [selectChildreanLabel setText:[NSString stringWithFormat:@"%d",auxnumber]];
            break;
        }
        case CURRENCY:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            [currencyLabel setText:[NSString stringWithFormat:@"%@",currency[auxnumber]]];
            break;
        }
        case COSTTYPE:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            [costTypeLabel setText:[NSString stringWithFormat:@"%@",cost_type[auxnumber]]];
            break;
        }
        case ROOMS:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            [selectRoomsLabel setText:[NSString stringWithFormat:@"%d",auxnumber +1]];
            break;
        }
        case STARTDATE:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            
            //[startDateLabel setText:startDates[auxnumber]];
            NSArray * dateArray = [startDates[auxnumber] componentsSeparatedByString:@","];
            
            NSString * myTempStr = [NSString stringWithFormat:@"%@",dateArray[1]];
            [startDateLabel setText:myTempStr];
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MM yyyy"];
            NSString *temp = myTempStr;
            NSArray * tempArray = [temp componentsSeparatedByString:@" "];
            int monthDay = [months indexOfObject:tempArray[1]] +1;
            NSString * formattedDate = [@[tempArray[0],[NSString stringWithFormat:@"%d",monthDay],tempArray[2]] componentsJoinedByString:@" "];
            //ComNSLog(@"formatted date---%@", formattedDate);
            startDateAux = [formatter dateFromString:formattedDate];
            //ComNSLog(@"start date aux---%@",startDateAux);
            //if([startDate compare:startDateAux] != 1){
//                [endDates removeAllObjects];
//                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//                dayComponent.day = 1;
//                NSCalendar *theCalendar = [NSCalendar currentCalendar];
//                
//                
//                for(int i=1; i<15; i++){
//                    NSDate *tempDate = startDateAux;
//                    
//                    dayComponent.day = i;
//                    tempDate = [theCalendar dateByAddingComponents:dayComponent toDate:tempDate options:0];
//                    
//                    NSArray * tempStringArray = [[formatter stringFromDate:tempDate] componentsSeparatedByString:@" "];
//                    
//                    NSString * tempMonth = months[[tempStringArray[1] intValue]-1];
//                    
//                    NSString *tempDateString = [NSString stringWithFormat:@"%@ %@ %@",tempStringArray[0], tempMonth, tempStringArray[2]];
//                    
//                    
//                    [endDates addObject:tempDateString];
//                }
//                
//                dayComponent.day =1;
//                //ComNSLog(@"compare---%d",[startDate compare:startDateAux]);
//                
//                
//                
//                //ComNSLog(@"end dates---%@",endDates);
//                [selectedRows setObject:[NSNumber numberWithInteger:0] atIndexedSubscript:ENDDATE];
//                [endDateLabel setText:[NSString stringWithFormat:@"%@",endDates[0]]];
           // }
            
            
            break;
        }
        case ENDDATE:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            
            //[endDateLabel setText:endDates[auxnumber]];
            
            NSArray * dateArray = [endDates[auxnumber] componentsSeparatedByString:@","];
            [endDateLabel setText:[NSString stringWithFormat:@"%@",dateArray[1]]];
            break;
        }
            
            
            
        default:
            break;
    }
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}


-(void)selectStartDate:(UITapGestureRecognizer *)recognizer{
//    [startDatePicker setDate:startDateAux];
//    [hideView setHidden:NO];
//    [startDatePickerView setHidden:NO];
//    [self.view bringSubviewToFront:startDatePicker];
    [dropDownLabel setText:@"De la"];
    [dropDownView setHidden:NO];
    [hideView setHidden:NO];
    dataArray = startDates;
    [dropDownTableVIew setFrame:CGRectMake(dropDownTableVIew.frame.origin.x,dropDownTableVIew.frame.origin.y , dropDownTableVIew.frame.size.width, 49 * [dataArray count] + dropDownTableVIew.frame.origin.y)];
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableVIew.frame.size.height + dropDownTableVIew.frame.origin.y + 49)];
    [dropDownTableVIew setTag:STARTDATE];
    [dropDownTableVIew reloadData];

    
}

-(void)selectEndDate:(UITapGestureRecognizer *) recognizer{
   
    
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd MM yyyy"];
//    
//    //ComNSLog(@"end:");
//    //ComNSLog(@"maximum %@",[formatter stringFromDate:endDatePicker.maximumDate]);
//    //ComNSLog(@"minimum %@",[formatter stringFromDate:endDatePicker.minimumDate]);
//    //ComNSLog(@"actual %@",[formatter stringFromDate:endDatePicker.date]);
//    
//    
//    NSDate * startDate = startDatePicker.date;
//    
//    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//    dayComponent.day = 1;
//    NSCalendar *theCalendar = [NSCalendar currentCalendar];
//
//    NSDate * minimunEndDate = [theCalendar dateByAddingComponents:dayComponent toDate:startDate options:0];
//    
//    if([endDateAux compare:minimunEndDate] == NSOrderedAscending){
//        endDateAux = minimunEndDate;
//    }
//    
//    //ComNSLog(@"select end date---%@",[formatter stringFromDate:minimunEndDate]);
//    //ComNSLog(@"end date aux---%@",[formatter stringFromDate:endDateAux]);
//    [endDatePicker setMinimumDate:minimunEndDate];
//    [endDatePicker setDate:endDateAux];
//    [hideView setHidden:NO];
//    [endDatePickerView setHidden:NO];
//    [self.view bringSubviewToFront:endDatePicker];
    
    [dropDownLabel setText:@"Pana la"];
    [dropDownView setHidden:NO];
    [hideView setHidden:NO];
    dataArray = endDates;
    [dropDownTableVIew setFrame:CGRectMake(dropDownTableVIew.frame.origin.x,dropDownTableVIew.frame.origin.y , dropDownTableVIew.frame.size.width, 49 * [dataArray count] + dropDownTableVIew.frame.origin.y)];
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableVIew.frame.size.height + dropDownTableVIew.frame.origin.y + 49)];
    [dropDownTableVIew setTag:ENDDATE];
    [dropDownTableVIew reloadData];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    //ComNSLog(@" textview did change");
    CGSize textViewSize = [self sizeOfText:otherTextView.text widthOfTextView:otherTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]];
    if(textViewSize.height < minimumSize.height){
        textViewSize = minimumSize;
    }
    
    otherTextView.contentInset = UIEdgeInsetsZero;
    otherTextView.showsHorizontalScrollIndicator = NO;
    otherTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    
    [otherTextView setFrame:CGRectMake(otherTextView.frame.origin.x, otherTextView.frame.origin.y, otherTextView.frame.size.width, textViewSize.height+8)];
    
    [otherView setFrame:CGRectMake(otherView.frame.origin.x, otherView.frame.origin.y, otherView.frame.size.width, otherTextView.frame.origin.y + otherTextView.frame.size.height)];
    

    [sendButton setFrame:CGRectMake(sendButton.frame.origin.x, otherView.frame.origin.y + otherView.frame.size.height +25, sendButton.frame.size.width, sendButton.frame.size.height)];

    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,  sendButton.frame.origin.y+ sendButton.frame.size.height + 25)];
    
    
    
}

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)calculateStartDate{
    


}

-(IBAction)changeStartDate:(UIButton *)sender{
    
    [startDatePickerView setHidden:YES];
    [endDatePickerView setHidden:YES];
    [hideView setHidden:YES];
    
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int currentWeekday = [weekdayComponents weekday]; //[1;7] ... 1 is sunday, 7 is saturday in gregorian calendar
    
    NSDateComponents *compStart = [[NSDateComponents alloc] init];
    NSDateComponents *compEnd = [[NSDateComponents alloc] init];
    [compEnd setDay:8- currentWeekday];
    
    startDate = [[NSCalendar currentCalendar] dateByAddingComponents:compStart toDate:startDatePicker.date options:0];
    
    [startDatePicker setDate:startDate];
    startDateAux = startDate;
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate * endDate = startDate;
    
    endDate = [theCalendar dateByAddingComponents:dayComponent toDate:endDate options:0];
    
    if([endDate compare:[NSDate date]] == NSOrderedAscending || [endDate compare:startDate] == NSOrderedAscending){
        [compEnd setDay:compEnd.day + 7];
        endDate = [[NSCalendar currentCalendar] dateByAddingComponents:compEnd toDate:[NSDate date] options:0];
    }
    
    
    dayComponent.day = 15;
    NSDate * maximumEndDate = startDate;
    maximumEndDate = [theCalendar dateByAddingComponents:dayComponent toDate:maximumEndDate options:0];
    
    [endDatePicker setMinimumDate:endDate];
    [endDatePicker setMaximumDate:maximumEndDate];
    [endDatePicker setDate:endDate];
    endDateAux = endDate;
    
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM yyyy"];
    //ComNSLog(@"end:");
    //ComNSLog(@"maximum %@",[formatter stringFromDate:endDatePicker.maximumDate]);
    //ComNSLog(@"minimum %@",[formatter stringFromDate:endDatePicker.minimumDate]);
    //ComNSLog(@"actual %@",[formatter stringFromDate:endDatePicker.date]);
    
    //start date
    
    NSArray * startStringArray = [[formatter stringFromDate:startDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * startMonth = months[[startStringArray[1] intValue]-1];
    
    NSString *startDateString = [NSString stringWithFormat:@"%@ %@ %@",startStringArray[0], startMonth, startStringArray[2]];
    
    //end date
    
    NSArray * endStringArray = [[formatter stringFromDate:endDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * endMonth = months[[endStringArray[1] intValue]-1];
    
    NSString *endDateString = [NSString stringWithFormat:@"%@ %@ %@",endStringArray[0], endMonth, endStringArray[2]];
    
    
    
    [startDateLabel setText:startDateString];
    [endDateLabel setText:endDateString];
    
}

-(IBAction)changeEndDate:(UIButton *)sender{
    
    //ComNSLog(@"change end date");
    
    [startDatePickerView setHidden:YES];
    [endDatePickerView setHidden:YES];
    [hideView setHidden:YES];
    


    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSDate * endDate = endDatePicker.date;

    [endDatePicker setDate:endDate];
    endDateAux = endDate;
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM yyyy"];
    
    
    //ComNSLog(@"minimum end date----%@", [formatter stringFromDate:endDatePicker.minimumDate]);
    //start date
    
    NSArray * startStringArray = [[formatter stringFromDate:startDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * startMonth = months[[startStringArray[1] intValue]-1];
    
    NSString *startDateString = [NSString stringWithFormat:@"%@ %@ %@",startStringArray[0], startMonth, startStringArray[2]];
    
    //end date
    
    NSArray * endStringArray = [[formatter stringFromDate:endDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * endMonth = months[[endStringArray[1] intValue]-1];
    
    NSString *endDateString = [NSString stringWithFormat:@"%@ %@ %@",endStringArray[0], endMonth, endStringArray[2]];
    
    
    
    [startDateLabel setText:startDateString];
    [endDateLabel setText:endDateString];
    
}

-(IBAction)cancelDateAction:(UIButton *)sender{
    [startDatePickerView setHidden:YES];
    [endDatePickerView setHidden:YES];
    [hideView setHidden:YES];
}


-(IBAction)backAction:(UIButton *)sender{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            [self dismissModalViewControllerAnimated:NO];
            [self prezintaBack];
            break;
        }
        case ReachableViaWiFi:
        {
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            [self dismissModalViewControllerAnimated:NO];
            [self prezintaBack];
            break;
        }
        case NotReachable:
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
            
    }

}

-(void)prezintaBack{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }
    
}


-(IBAction)bookingRequest:(UIButton *)sender{
    
    //    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:@[@{@"type":[NSNumber numberWithInt:0], @"text":@"Numele introdus"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Adresa de email introdusa"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Numarul de telefon introdus"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Numarul de camere ales"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Numarul de adulti ales"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Suma alocata"}]];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM yyyy"];
    
    NSString * temp = startDateLabel.text;
   // NSArray * tempArray = [temp componentsSeparatedByString:@","];
    NSString *startTemp = [temp stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
    NSArray * startTempArray = [startTemp componentsSeparatedByString:@" "];
    int monthDay = [months indexOfObject:startTempArray[1]] +1;
    NSString * formattedDate = [@[startTempArray[0],[NSString stringWithFormat:@"%d",monthDay],startTempArray[2]] componentsJoinedByString:@" "];
    
    NSDate *mStartDate = [formatter dateFromString:formattedDate];
    
    
    
    NSString * temp1 = endDateLabel.text;
    //NSArray * temp1Array = [temp1 componentsSeparatedByString:@","];
    NSString *endTemp = [temp1 stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
    
    NSArray *endTempArray = [endTemp componentsSeparatedByString:@" "];
    monthDay = [months indexOfObject:endTempArray[1]] +1;
    formattedDate = [@[endTempArray[0],[NSString stringWithFormat:@"%d",monthDay],endTempArray[2]] componentsJoinedByString:@" "];
    
    NSDate *mEndDate = [formatter dateFromString:formattedDate];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:mStartDate toDate:mEndDate options:0];
    
    
    if([difference day] > 15){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Perioada de cazare nu poate depasi 15 zile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }

    else{
        if([mEndDate compare:mStartDate] == NSOrderedAscending){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Perioada selectata de dumneavoastra este invalida" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else{
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:@[@{@"type":[NSNumber numberWithInt:0], @"text1":@"Numele trebuie completat",@"text2":@"Numele introdus este invalid"},@{@"type":[NSNumber numberWithInt:0], @"text2":@"Adresa de email introdusa este invalida", @"text1":@"Adresa de email trebuie introdusa"},@{@"type":[NSNumber numberWithInt:0], @"text2":@"Numarul de telefon introdus este invalid", @"text1":@"Numarul de telefon trebuie completat"},@{@"type":[NSNumber numberWithInt:0], @"text1":@"Numarul de camere trebuie completat",@"text2":@""},@{@"type":[NSNumber numberWithInt:0], @"text1":@"Bugetul alocat trebuie completat",@"text2":@""}]];
            
            
            if(touristName.text.length == 0){
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[0]];
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                [tempArray setObject:dict atIndexedSubscript:0];
            }
            else{
                if(![self NSStringisValidName:touristName.text]){
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[0]];
                    [dict setObject:[NSNumber numberWithInt:2] forKey:@"type"];
                    [tempArray setObject:dict atIndexedSubscript:0];
                }
            }
            
            
            if(touristMail.text.length == 0){
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[1]];
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                [tempArray setObject:dict atIndexedSubscript:1];
            }
            else{
                if(![self NSStringIsValidEmail:touristMail.text]){
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[1]];
                    [dict setObject:[NSNumber numberWithInt:2] forKey:@"type"];
                    [tempArray setObject:dict atIndexedSubscript:1];
                }
            }
            
            
            //    if(touristPhone.text.length == 0){
            //        NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[2]];
            //        [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
            //        [tempArray setObject:dict atIndexedSubscript:2];
            //    }
            //    else{
            //        if(![self NSStringisValidName:touristName.text]){
            //            NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[2]];
            //            [dict setObject:[NSNumber numberWithInt:2] forKey:@"type"];
            //            [tempArray setObject:dict atIndexedSubscript:2];
            //        }
            //    }
            
            
            if(touristPhone.text.length == 0){
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[2]];
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                [tempArray setObject:dict atIndexedSubscript:2];
            }
            else{
                if(![self phoneCheck:touristPhone.text]){
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[2]];
                    [dict setObject:[NSNumber numberWithInt:2] forKey:@"type"];
                    [tempArray setObject:dict atIndexedSubscript:2];
                }
            }
            
            
            int countRooms = [selectRoomsLabel.text intValue];
            
            if(!countRooms){
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[3]];
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                [tempArray setObject:dict atIndexedSubscript:3];
            }
            
            
            int budgetx = [totalCost.text intValue];
            
            if(!budgetx){
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[4]];
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                [tempArray setObject:dict atIndexedSubscript:4];
            }
            
            
            
                int numberOfAdults = [selectAdultsLabel.text intValue];
            
            //    if(numberOfAdults){
            //        NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[4]];
            //        [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
            //        [tempArray setObject:dict atIndexedSubscript:4];
            //    }
            
            
                int numberOfChildrean = [selectChildreanLabel.text intValue];
            //
            //    if(numberOfChildrean){
            //        NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[5]];
            //        [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
            //        [tempArray setObject:dict atIndexedSubscript:5];
            //    }
            
            
            NSString * str = @"";
            
            for(int i=0; i< [tempArray count]; i++){
                NSDictionary * dict = tempArray[i];
                if([dict[@"type"] intValue] == 1 ){
                    str = [str stringByAppendingFormat:@"%@\n",dict[@"text1"]];
                }
                else{
                    if([dict[@"type"] intValue] == 2){
                        str = [str stringByAppendingFormat:@"%@\n",dict[@"text2"]];
                    }
                }
            }
            
            if(str.length == 0){
                
                
                //construim vector de id-uri
                idsPensiuni = [[NSMutableArray alloc] init];
                
                for(int i=0; i< [myJson count]; i++){
                    NSDictionary * pensiune = myJson[i];
                    [idsPensiuni addObject:pensiune[@"id"]];
                }
                
                //ComNSLog(@"ids:   %@",idsPensiuni);
                //ComNSLog(@"nume: %@",touristName.text);
                //ComNSLog(@"email: %@",touristMail.text);
                //ComNSLog(@"telefon: %@",touristPhone.text);
                //ComNSLog(@"dela: %f",[mStartDate timeIntervalSince1970]);
                //ComNSLog(@"panala: %f", [mEndDate timeIntervalSince1970]);
                //ComNSLog(@"datefelxibile: %d",switchBtn.isSelected);
                //ComNSLog(@"camere: %d",countRooms);
                //ComNSLog(@"adulti: %d",numberOfAdults);
                //ComNSLog(@"children: %d", numberOfChildrean);
                //ComNSLog(@"buget: %d",budgetx);
                //ComNSLog(@"moneda: %@",currencyLabel.text);
                
                MKNetworkEngine *engine;    //engine de request web get post
                engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
                NSString *path_proces = [[NSString alloc]init];
                path_proces =@"/app_cr/cerere/?id=myx1j3";
                
                int tip_cost = 1;
                for(int i=0; i< [cost_type count]; i++){
                   // NSString * key = [NSString stringWithFormat:@"%d",i+1];
                    if([cost_type[i] isEqualToString:costTypeLabel.text]){
                        tip_cost = i+1;
                    }
                }
                NSError * error;
                NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:idsPensiuni options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
//                //ComNSLog(@"str:  %@",[jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@""]);
                
                NSMutableDictionary * param2 =[NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"idsPensiuni"
                                                ,[NSNumber numberWithDouble:[mStartDate timeIntervalSince1970]],@"deLa",
                                                [NSNumber numberWithDouble:[mEndDate timeIntervalSince1970]],@"panaLa",
                                                touristName.text,@"nume",
                                                touristMail.text,@"email",
                                                touristPhone.text,@"telefon",
                                                @true,@"dateFlexibile",
                                                [NSNumber numberWithInt:numberOfAdults], @"adulti",
                                                [NSNumber numberWithInt:numberOfChildrean], @"copii",
                                                [NSNumber numberWithInt:countRooms] ,@"camere",
                                                [NSNumber numberWithInt:budgetx], @"buget",
                                                currencyLabel.text,@"moneda",
                                                [NSNumber numberWithInt:tip_cost],@"tipSuma",otherTextView.text,@"cerinte",nil];

                //ComNSLog(@"param2---%@", param2);

                MKNetworkOperation *op = [engine operationWithPath:path_proces
                                                            params:param2
                                                        httpMethod:@"POST"];
                
                
                //op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
                [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                    //NSData *rezultat_REQ4 = [completedOperation responseData];
                    //NSString *rez_poze  = [completedOperation responseString];
                    NSDictionary *resp = [completedOperation responseJSON];
                    NSString * status = resp[@"status"];
                    NSString * msg = @"";
                    NSString * title = @"";
                    if([status isEqualToString:@"OK"]){
                        msg = resp[@"error"];
                        title = @"Felicitari!";
                    }
                    else{
                        msg = resp[@"error"];
                        title = @"Atentie!";
                    }
//                    //ComNSLog(@"resp:  %@",resp);
                    
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    alert.tag = 666;
                    [alert show];

                    
                }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                    //ComNSLog(@"%@", error); //show err
                }];
                [engine enqueueOperation: op];
                
            }
            else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
            }
            
            //ComNSLog(@"str---%@",str);
            
            
            //ComNSLog(@"temp array---%@",tempArray);
            
            
        }

    }
    
    
    
    
}

-(void)moveForms{
    // muta informatii turist
    CGRect touristRect = touristView.frame;
    touristRect.origin.y = CGRectGetMaxY(warningMessage.frame) + 10;
    [touristView setFrame:touristRect];
    
    // muta date picker
    CGRect selectDateRect = selectDateView.frame;
    selectDateRect.origin.y = CGRectGetMaxY(touristView.frame);
    [selectDateView setFrame:selectDateRect];
    
    //muta numar persoane si camere
    CGRect selectPeopleRect = selectRoomsAndPeopleView.frame;
    selectPeopleRect.origin.y = CGRectGetMaxY(selectDateView.frame);
    [selectRoomsAndPeopleView setFrame:selectPeopleRect];
    
    //muta buget
    CGRect bugetRect = budgetView.frame;
    bugetRect.origin.y = CGRectGetMaxY(selectRoomsAndPeopleView.frame);
    [budgetView setFrame:bugetRect];
    
    //muta alte cerinte
    CGRect otherRect = otherView.frame;
    otherRect.origin.y = CGRectGetMaxY(budgetView.frame);
    [otherView setFrame:otherRect];
    
    //muta buton trimite
    [sendButton setFrame:CGRectMake(sendButton.frame.origin.x, otherView.frame.origin.y + otherView.frame.size.height +25, sendButton.frame.size.width, sendButton.frame.size.height)];
    
    //actualizeaza contentsize scroll
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,  sendButton.frame.origin.y+ sendButton.frame.size.height + 25)];
    
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 666){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:touristName.text forKey:@"Nume.Cazare.ro"];
        [defaults setObject:touristMail.text forKey:@"Mail.Cazare.ro"];
        [defaults setObject:touristPhone.text forKey:@"Phone.Cazare.ro"];
        [defaults synchronize];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:transition forKey:nil];
//        [[[self presentingViewController] presentingViewController]  dismissModalViewControllerAnimated:NO];
//        StartViewController *ECRAN1Screen = [[StartViewController alloc] initWithNibName:@"StartViewController" bundle:nil];
//        UINavigationController * navigationController = self.navigationController;
//        [navigationController popToRootViewControllerAnimated:NO];
//        [navigationController pushViewController:ECRAN1Screen animated:NO];
        
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for( int i=0;i<[viewControllers count];i++){
            id obj=[viewControllers objectAtIndex:i];
            if([obj isKindOfClass:[StartViewController class]]){
                [[self navigationController] popToViewController:obj animated:NO];
                return;
                
            }
        }
        
    }
    
}


-(BOOL)phoneCheck:(NSString *)text
{
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    bool isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    if (text.length==10 && isValid)
    {
        isValid=YES;
    }
    else
    {
        isValid=NO;
    }
    return isValid;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)SWITCHCONOFF {
    switchBtn.selected =! switchBtn.selected;
}

@end
