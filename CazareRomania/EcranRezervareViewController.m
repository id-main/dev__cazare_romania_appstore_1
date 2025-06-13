//
//  EcranRezervareViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 13/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranRezervareViewController.h"
#import "FeeTableViewCell.h"
#import <Quartzcore/QuartzCore.h>
#import "DropDownTableViewCell.h"
#import "EcranCerereOfertaViewController.h"
#import "StartViewController.h"

#define STARTDATE 1
#define ENDDATE 2

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface EcranRezervareViewController ()

@end

@implementation EcranRezervareViewController
@synthesize backButton, backLabel, backView,mainScrollView,startDateLabel,endDateLabel,startView,endView, selectDateView, locationLabel, selectRoomsView, feesTableView, childrenLabel, adultLabel, childrenView,adultView,selectPeople, extraFacilitiesTextView, extraFacilitiesView, contactDataView, touristMail, touristName, touristPhone, bookingButton, extraFacilitiesLabel, dropDownScrollView, dropDownTableView,dropDownView, hideView,adultDropDownScrollView, adultDropDownTableView, adultDropDownView, childrenDropDownScrollView, childrenDropDownTableView, childrenDropDownView, adultBigView, childrenBigView,startDatePicker,endDatePicker,startDatePickerView, endDatePickerView, startDateDoneButton, endDateDoneButton, nameLabel,myJson,roomsSelectionArray,dateDropDownView, tableDateDropDown, dateDropDownScrollView, dateDropDownLabel, pageTitleLabel, selectDateTitleLabel, selectRoomsTitleLabel, otherRequirementsLabel, adultsLabel, childreanLabel, startLabel, endLabel, sepAdults, sepChildrean, dateSep1, dateSep2, dateSep3, sepSelectRooms, topSepSelectRooms, greenBorder, roomDropDownLabel, adultDropDownLabel,childreanDropDownLabel;


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
    
    [mainScrollView setScrollsToTop:YES];
    [dropDownTableView setScrollsToTop:NO];
    [dropDownScrollView setScrollsToTop:NO];
    [adultDropDownScrollView setScrollsToTop:NO];
    [adultDropDownTableView setScrollsToTop:NO];
    [childrenDropDownScrollView setScrollsToTop:NO];
    [childrenDropDownTableView setScrollsToTop:NO];
    [tableDateDropDown setScrollsToTop:NO];
    [dateDropDownScrollView setScrollsToTop:NO];
    [feesTableView setScrollsToTop:NO];
    [extraFacilitiesTextView setScrollsToTop:NO];
    


    
    room_icons = @{@"2pers":@"camera_dubla_m.png",@"2persm":@"camera_matrimoniala_m.png",@"1pers":@"camera_single_m.png",@"3pers":@"camera_tripla_m.png",@"1persg":@"garsoniera_m.png",@"4pers":@"apartament_m.png",@"all":@"toata_unitatea_m.png"};
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
    
    //ComNSLog(@"end picker minimum---%@", [formatter stringFromDate:endLowLimitDate]);
    
    [endDatePicker setMinimumDate:endLowLimitDate];
    [endDatePicker setMaximumDate:endLimitDate];
    [endDatePicker setDate:endDate];
    endDateAux = endDate;
    
    
    

    
    //start date
    
    NSDateComponents *comps = [theCalendar components:NSWeekdayCalendarUnit fromDate:startDatePicker.date];
    int weekday = [comps weekday];
    
    NSArray * tempStringArray = [[formatter stringFromDate:startDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * tempMonth = months[[tempStringArray[1] intValue]-1];
    
//    NSString *startDateString = [NSString stringWithFormat:@"%@, %@ %@ %@",weekDays[weekday-1],tempStringArray[0], tempMonth, tempStringArray[2]];
    
    NSString *startDateString = [NSString stringWithFormat:@" %@ %@ %@",tempStringArray[0], tempMonth, tempStringArray[2]];
    
//    NSArray * startStringArray = [[formatter stringFromDate:startDatePicker.date] componentsSeparatedByString:@" "];
//    
//    NSString * startMonth = months[[startStringArray[1] intValue]-1];
//    
//    NSString *startDateString = [NSString stringWithFormat:@"%@ %@ %@",startStringArray[0], startMonth, startStringArray[2]];
    
    //end date
    
//    NSDateComponents *compsEnd = [theCalendar components:NSWeekdayCalendarUnit fromDate:endDatePicker.date];
//    int weekdayEnd = [compsEnd weekday];
    
    NSArray * tempStringArrayEnd = [[formatter stringFromDate:endDatePicker.date] componentsSeparatedByString:@" "];
    
    NSString * tempMonthEnd = months[[tempStringArray[1] intValue]-1];
    
    NSString *endDateString = [NSString stringWithFormat:@" %@ %@ %@",tempStringArrayEnd[0], tempMonthEnd, tempStringArrayEnd[2]];
    
//    NSArray * endStringArray = [[formatter stringFromDate:endDatePicker.date] componentsSeparatedByString:@" "];
//    
//    NSString * endMonth = months[[endStringArray[1] intValue]-1];
//    
//    NSString *endDateString = [NSString stringWithFormat:@"%@ %@ %@",endStringArray[0], endMonth, endStringArray[2]];
    
    
    
    [startDateLabel setText:startDateString];
    [endDateLabel setText:endDateString];
    [mainScrollView setBounces:YES];
    
//     myJson = @{@"status":@"OK",@"results":@{@"id":@6137,@"nume":@"Casa Germana",@"tip":@"Pensiunea",@"categorie":@3,@"fotos":@[@"http://www.infopensiuni.ro/poze/uc/68884.JPG",@"http://www.infopensiuni.ro/poze/uc/68883.JPG",@"http://www.infopensiuni.ro/poze/uc/68882.jpg",@"http://www.infopensiuni.ro/poze/uc/68881.jpg",@"http://www.infopensiuni.ro/poze/uc/68880.jpg",@"http://www.infopensiuni.ro/poze/uc/68879.jpg",@"http://www.infopensiuni.ro/poze/uc/68878.jpg",@"http://www.infopensiuni.ro/poze/uc/68877.jpg",@"http://www.infopensiuni.ro/poze/uc/68876.JPG",@"http://www.infopensiuni.ro/poze/uc/68875.JPG"],@"gps":@[@45.365655,@23.254852],@"adresa":@"Str Straja FN",@"localitate":@{@"id":@610,@"idJudet":@33,@"nume":@"Straja"},@"judet":@{@"id":@33,@"nume":@"Hunedoara"},@"urlShare":@"http://www.infopensiuni.ro/cazare-straja/pensiuni-straja/pensiunea-casa-germana",@"persContact":@"Vladislav Liliana",@"telefon":@"0768.735.229",@"email":[NSNull null],@"facilitati":@[],@"descriere":@"Casa Germana este situata la aproximativ 50m de intoarcerea telescaunului si teleschiul 3, pe drumul catre schitul Straja.<br />Va asteptam sa petreceti o vacanta la munte intr-o ambianta de neuitat.<br /><br />Pensiunea dispune de 20 locuri de cazare:<br /><br />-2 camere de 4 loc. Cu baie proprie<br />-2 camere de 2 loc cu baie proprie<br />-1 camera de 2 loc. Cu baie proprie si pat pt. Copii<br />-3 camere matrimoniale cu acces la o singura baie.<br /><br />Toate camerele sunt dotate cu Tv, Internet Wireless.<br /><br />Pensiunea dispune de un restaurant cu o capacitate de 25 locuri unde puteti servi mancaruri dintr-un meniu diversificat la preturi exceptionale.<br /><br />De asemenea se pot organiza mese festive in limita locurilor disponibile.<br /><br />Beneficiati gratuit de urmatoarele servicii :<br /><br />- ghid montan pentru trasee turistice pedestre<br />- tiroliana<br />- alpinism<br />- orientare turistica<br /><br />Va asteptam cu drag.",@"htmlPersonalizat":[NSNull null],@"tarife":@[@{@"idCamera":@21836,@"nume":@"Camera dubla",@"suma":@80,@"moneda":@"RON",@"dataDeLa":@"2014-05-14",@"dataPanaLa":@"2014-05-15",@"nrNopti":@1,@"tip":@"noapte",@"icon":@"2pers"},@{@"idCamera":@19115,@"nume":@"Camera dubla matrimoniala",@"suma":@50,@"moneda":@"RON",@"dataDeLa":@"2014-05-14",@"dataPanaLa":@"2014-05-15",@"nrNopti":@1,@"tip":@"noapte",@"icon":@"2pers"},@{@"idCamera":@19116,@"nume":@"Apartament",@"suma":@120,@"moneda":@"RON",@"dataDeLa":@"2014-05-14",@"dataPanaLa":@"2014-05-15",@"nrNopti":@1,@"tip":@"noapte",@"icon":@"4pers"}],@"comentarii":@[],@"obiective":@[@{@"id":@4487,@"nume":@"Cascada Miralas",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/",@"distanta":@"4 min cu masina"},@{@"id":@6663,@"nume":@"Partie ski Mutu (Slalom Urias) Straja",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/partiamutu.jpg",@"distanta":@"9 min cu masina"},@{@"id":@6667,@"nume":@"Partie ski Sf. Gheorghe Straja",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/harta_partiistraja.jpg",@"distanta":@"9 min cu masina"}]}}[@"results"];
    
    self.myJson = myJson;
    
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
    
    //ComNSLog(@"start dates---%@",startDates);
    //ComNSLog(@"end dates---%@",endDates);
    //ComNSLog(@"selected rows---%@",selectedRows);
    
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        //ComNSLog(@"from landscape");
        
        CGSize textViewSize = [self sizeOfText:extraFacilitiesTextView.text widthOfTextView:extraFacilitiesTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]];
        if(textViewSize.height < minimumSize.height){
            textViewSize = minimumSize;
        }
        
        extraFacilitiesTextView.contentInset = UIEdgeInsetsZero;
        extraFacilitiesTextView.showsHorizontalScrollIndicator = NO;
        extraFacilitiesTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        
        [extraFacilitiesTextView setFrame:CGRectMake(extraFacilitiesTextView.frame.origin.x, extraFacilitiesTextView.frame.origin.y, extraFacilitiesTextView.frame.size.width, textViewSize.height +8)];
        
        [extraFacilitiesView setFrame:CGRectMake(extraFacilitiesView.frame.origin.x, selectPeople.frame.origin.y + selectPeople.frame.size.height, extraFacilitiesView.frame.size.width, extraFacilitiesTextView.frame.origin.y + extraFacilitiesTextView.frame.size.height)];
        
        
//        [contactDataView setFrame:CGRectMake(contactDataView.frame.origin.x, extraFacilitiesView.frame.origin.y + extraFacilitiesView.frame.size.height, contactDataView.frame.size.width, contactDataView.frame.size.height)];
        
        [bookingButton setFrame:CGRectMake(bookingButton.frame.origin.x, CGRectGetMaxY(extraFacilitiesView.frame) + 25, bookingButton.frame.size.width, bookingButton.frame.size.height)];
        
        [mainScrollView setShowsHorizontalScrollIndicator:NO];
        [mainScrollView setShowsVerticalScrollIndicator:NO];
        
        if([[UIScreen mainScreen] bounds].size.height > 480 ){
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height+25)];
        }
        else{
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height + 25)];
        }
        
        int xPos, yPos;
        xPos = 20;//(self.view.bounds.size.width - 250) /2;
        yPos = ([[UIScreen mainScreen] bounds].size.height - dropDownView.frame.size.height) /2;
        
        [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
        
        [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableView.frame.size.height + dropDownTableView.frame.origin.y)];
        
        
        int xPosA, yPosA;
        xPosA = 20;
        yPosA = ([[UIScreen mainScreen] bounds].size.height - adultDropDownView.frame.size.height) /2;
        
        [adultDropDownView setFrame:CGRectMake(xPosA, yPosA, self.view.bounds.size.width -40, adultDropDownView.frame.size.height)];
        
        [adultDropDownScrollView setContentSize:CGSizeMake(adultDropDownView.frame.size.width, adultDropDownTableView.frame.size.height + adultDropDownTableView.frame.origin.y)];
        int xPosC, yPosC;
        xPosC = 20; //(self.view.frame.size.width - childrenDropDownView.frame.size.width) /2;
        yPosC = ([[UIScreen mainScreen] bounds].size.height - childrenDropDownView.frame.size.height) /2;
        
        [childrenDropDownView setFrame:CGRectMake(xPosC, yPosC, self.view.bounds.size.width -40, childrenDropDownView.frame.size.height)];
        
        [childrenDropDownScrollView setContentSize:CGSizeMake(childrenDropDownView.frame.size.width, childrenDropDownTableView.frame.size.height + childrenDropDownTableView.frame.origin.y)];
        int xPosD, yPosD;
        xPosD = 20;//(self.view.frame.size.width - dateDropDownView.frame.size.width) /2;
        yPosD = ([[UIScreen mainScreen] bounds].size.height - dateDropDownView.frame.size.height) /2;
        
        [dateDropDownView setFrame:CGRectMake(xPosC, yPosC, self.view.bounds.size.width -40, dateDropDownView.frame.size.height)];
        
        

        
    }
    else{
        //ComNSLog(@"from portrait");
        
        CGSize textViewSize = [self sizeOfText:extraFacilitiesTextView.text widthOfTextView:extraFacilitiesTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]];
        if(textViewSize.height < minimumSize.height){
            textViewSize = minimumSize;
        }
        
        extraFacilitiesTextView.contentInset = UIEdgeInsetsZero;
        extraFacilitiesTextView.showsHorizontalScrollIndicator = NO;
        extraFacilitiesTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        
        [extraFacilitiesTextView setFrame:CGRectMake(extraFacilitiesTextView.frame.origin.x, extraFacilitiesTextView.frame.origin.y, extraFacilitiesTextView.frame.size.width, textViewSize.height +8)];
        
        [extraFacilitiesView setFrame:CGRectMake(extraFacilitiesView.frame.origin.x, selectPeople.frame.origin.y + selectPeople.frame.size.height, extraFacilitiesView.frame.size.width, extraFacilitiesTextView.frame.origin.y + extraFacilitiesTextView.frame.size.height)];
        
        
//        [contactDataView setFrame:CGRectMake(contactDataView.frame.origin.x, extraFacilitiesView.frame.origin.y + extraFacilitiesView.frame.size.height, contactDataView.frame.size.width, contactDataView.frame.size.height)];
        
        [bookingButton setFrame:CGRectMake(bookingButton.frame.origin.x, CGRectGetMaxY(extraFacilitiesView.frame) + 25, bookingButton.frame.size.width, bookingButton.frame.size.height)];
        
        [mainScrollView setShowsHorizontalScrollIndicator:NO];
        [mainScrollView setShowsVerticalScrollIndicator:NO];
        
        if([[UIScreen mainScreen] bounds].size.height > 480 ){
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height+25)];
        }
        else{
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height + 25)];
        }
        
        int xPos, yPos;
        xPos = 20;//(self.view.bounds.size.width - 250) /2;
        yPos = ([[UIScreen mainScreen] bounds].size.width - dropDownView.frame.size.height) /2;
        
        [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
        
        [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableView.frame.size.height + dropDownTableView.frame.origin.y)];
        
        
        int xPosA, yPosA;
        xPosA = 20;
        yPosA = ([[UIScreen mainScreen] bounds].size.width - adultDropDownView.frame.size.height) /2;
        
        [adultDropDownView setFrame:CGRectMake(xPosA, yPosA, self.view.bounds.size.width -40, adultDropDownView.frame.size.height)];
        
        [adultDropDownScrollView setContentSize:CGSizeMake(adultDropDownView.frame.size.width, adultDropDownTableView.frame.size.height + adultDropDownTableView.frame.origin.y)];
        int xPosC, yPosC;
        xPosC = 20; //(self.view.frame.size.width - childrenDropDownView.frame.size.width) /2;
        yPosC = ([[UIScreen mainScreen] bounds].size.width - childrenDropDownView.frame.size.height) /2;
        
        [childrenDropDownView setFrame:CGRectMake(xPosC, yPosC, self.view.bounds.size.width -40, childrenDropDownView.frame.size.height)];
        
        [childrenDropDownScrollView setContentSize:CGSizeMake(childrenDropDownView.frame.size.width, childrenDropDownTableView.frame.size.height + childrenDropDownTableView.frame.origin.y)];
        int xPosD, yPosD;
        xPosD = 20;//(self.view.frame.size.width - dateDropDownView.frame.size.width) /2;
        yPosD = ([[UIScreen mainScreen] bounds].size.width - dateDropDownView.frame.size.height) /2;
        
        [dateDropDownView setFrame:CGRectMake(xPosC, yPosC, self.view.bounds.size.width -40, dateDropDownView.frame.size.height)];

    }
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
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
    
    //ComNSLog(@"myJson----%@", myJson);
    
    
    [backButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    
    [adultDropDownTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [childrenDropDownTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [dropDownTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableDateDropDown setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * name = [defaults objectForKey:@"Nume.Cazare.ro"];
    NSString * mail = [defaults objectForKey:@"Mail.Cazare.ro"];
    NSString * phone = [defaults objectForKey:@"Phone.Cazare.ro"];
    
    [greenBorder setBackgroundColor:UIColorFromRGB(0x94af39)];
    if(name.length > 0){
        [touristName setText:name];
    }
    if(phone.length > 0){
        [touristPhone setText:phone];
    }
    if(mail.length > 0){
        [touristMail setText:mail];
    }
    
    [bookingButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    
    [backLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [pageTitleLabel setFont:[UIFont fontWithName:@"OpenSans" size:21.5f]];
    
    [nameLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [nameLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [locationLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [locationLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [selectDateTitleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [selectDateTitleLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [selectRoomsTitleLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [selectRoomsTitleLabel setTextColor:UIColorFromRGB(0x666666)];
    
    
    [otherRequirementsLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [otherRequirementsLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [childreanLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [childreanLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [adultsLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [adultsLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [startDateLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [startDateLabel setTextColor:UIColorFromRGB(0xcb314b)];
    
    [endDateLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [endDateLabel setTextColor:UIColorFromRGB(0xcb314b)];
    
    [startLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [startLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [endLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [endLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [sepAdults setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [sepChildrean setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [sepSelectRooms setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [dateSep1 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [dateSep2 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [dateSep3 setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [topSepSelectRooms setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    CGRect sepAdultsFrame = sepAdults.frame;
    [sepAdults setFrame:CGRectMake(sepAdultsFrame.origin.x+0.5, sepAdultsFrame.origin.y, 0.5, sepAdultsFrame.size.height)];
    
    CGRect sepChildFrame = sepChildrean.frame;
    [sepChildrean setFrame:CGRectMake(sepChildFrame.origin.x+0.5, sepChildFrame.origin.y, 0.5, sepChildFrame.size.height)];
    
    CGRect sepRoomsFrame = sepSelectRooms.frame;
    [sepSelectRooms setFrame:CGRectMake(sepRoomsFrame.origin.x, sepRoomsFrame.origin.y +0.5,sepRoomsFrame.size.width, 0.5)];
    
    [selectRoomsView bringSubviewToFront:sepSelectRooms];
    //ComNSLog(@"sep select rooms:   %@", NSStringFromCGRect(sepSelectRooms.frame));
    //ComNSLog(@"tabel framel:   %@", NSStringFromCGRect(feesTableView.frame));
    
    CGRect sepDate1Frame = dateSep1.frame;
    [dateSep1 setFrame:CGRectMake(sepDate1Frame.origin.x, sepDate1Frame.origin.y +0.5,sepDate1Frame.size.width ,0.5)];
    
    CGRect sepDate2Frame = dateSep2.frame;
    [dateSep2 setFrame:CGRectMake(sepDate2Frame.origin.x, sepDate2Frame.origin.y +0.5,sepDate2Frame.size.width ,0.5)];
    
    CGRect sepDate3Frame = dateSep3.frame;
    [dateSep3 setFrame:CGRectMake(sepDate3Frame.origin.x, sepDate3Frame.origin.y +0.5,sepDate3Frame.size.width ,0.5)];
    
    CGRect topSepFrame = topSepSelectRooms.frame;
    [topSepSelectRooms setFrame:CGRectMake(topSepFrame.origin.x, topSepFrame.origin.y +0.5,topSepFrame.size.width ,0.5)];
    

    dateSep1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    dateSep2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    dateSep3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    topSepSelectRooms.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    sepSelectRooms.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    
    [adultLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [adultLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [childrenLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [childrenLabel setTextColor:UIColorFromRGB(0x666666)];
    
    
    [roomDropDownLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [roomDropDownLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [childreanDropDownLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [childreanDropDownLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [adultDropDownLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [adultDropDownLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [dateDropDownLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.5f]];
    [dateDropDownLabel setTextColor:UIColorFromRGB(0x666666)];
    
//    [feesTableView setSeparatorColor:UIColorFromRGB(0xe5e5e5)];
    
    [feesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    // setare data acces
    
    [nameLabel setText:myJson[@"nume"]];
    [locationLabel setText:myJson[@"localitate"][@"nume"]];
    
    
    
    
    [selectDateView setFrame:CGRectMake(selectDateView.frame.origin.x,locationLabel.frame.size.height+ locationLabel.frame.origin.y,self.view.bounds.size.width,selectDateView.frame.size.height)];
    

   
    
    [mainScrollView addSubview:selectDateView];
    [mainScrollView addSubview:selectRoomsView];
    
    
    
    // adauga tabel tarife
    
    //feesArray = @[@{@"type":@"Single",@"fee":@"89 Lei"},@{@"type":@"Double",@"fee":@"99 Lei"},@{@"type":@"Triple",@"fee":@"139 Lei"}];
    feesArray = myJson[@"tarife"];
    
    [selectRoomsView setFrame:CGRectMake(selectRoomsView.frame.origin.x, selectDateView.frame.origin.y+selectDateView.frame.size.height, self.view.bounds.size.width, selectRoomsView.frame.size.height)];
    
    
    [feesTableView setFrame:CGRectMake(feesTableView.frame.origin.x, feesTableView.frame.origin.y, feesTableView.frame.size.width, 49*[feesArray count])];
    
    
    //    [feesTableView.layer setBorderWidth:1];
    //    [feesTableView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [feesTableView setScrollEnabled:NO];
    [feesTableView setNeedsLayout];
    [feesTableView setNeedsDisplay];
    
    int mHeight = feesTableView.frame.size.height + feesTableView.frame.origin.y;
    CGRect tempFrame = selectRoomsView.frame;
    tempFrame.size.height = mHeight;
    
    [selectRoomsView setFrame:tempFrame];
    
    UIView * feesSepView = [[UIView alloc] initWithFrame:CGRectMake(feesTableView.frame.origin.x,feesTableView.frame.origin.y -0.5, feesTableView.frame.size.width,0.5)];
    [feesSepView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
     feesSepView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [selectRoomsView addSubview:feesSepView];
    [selectRoomsView bringSubviewToFront:feesSepView];
    
    topSepSelectRooms.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [mainScrollView addSubview:selectPeople];
    
    [selectPeople setFrame:CGRectMake(selectPeople.frame.origin.x, selectRoomsView.frame.origin.y + selectRoomsView.frame.size.height, self.view.bounds.size.width, selectPeople.frame.size.height)];
    
    [adultView.layer setCornerRadius:5];
    [adultView.layer setBorderColor:UIColorFromRGB(0xe5e5e5).CGColor];
    [adultView.layer setBorderWidth:0.5f];
    
    [childrenView.layer setCornerRadius:5];
    [childrenView.layer setBorderColor:UIColorFromRGB(0xe5e5e5).CGColor];
    [childrenView.layer setBorderWidth:0.5f];
    
    [mainScrollView addSubview:extraFacilitiesView];
    
    minimumSize = extraFacilitiesTextView.frame.size;
    
    extraFacilitiesTextView.layer.cornerRadius = 5.0;
    extraFacilitiesTextView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    extraFacilitiesTextView.layer.borderWidth = 0.5;
    extraFacilitiesTextView.layer.masksToBounds = YES;
    [extraFacilitiesTextView setScrollEnabled:NO];
    
    CGSize textViewSize = [self sizeOfText:extraFacilitiesTextView.text widthOfTextView:extraFacilitiesTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]];
    if(textViewSize.height < minimumSize.height){
        textViewSize = minimumSize;
    }
    
    
    
    
    extraFacilitiesTextView.contentInset = UIEdgeInsetsZero;
    extraFacilitiesTextView.showsHorizontalScrollIndicator = NO;
    extraFacilitiesTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    
    [extraFacilitiesView setFrame:CGRectMake(extraFacilitiesView.frame.origin.x, selectPeople.frame.origin.y + selectPeople.frame.size.height, self.view.bounds.size.width, extraFacilitiesTextView.frame.origin.y + extraFacilitiesTextView.frame.size.height)];
    
    [extraFacilitiesTextView setFrame:CGRectMake(extraFacilitiesTextView.frame.origin.x, extraFacilitiesTextView.frame.origin.y, extraFacilitiesTextView.frame.size.width, textViewSize.height)];
    
   
    

    
//    [contactDataView setFrame:CGRectMake(contactDataView.frame.origin.x, extraFacilitiesView.frame.origin.y + extraFacilitiesView.frame.size.height, self.view.bounds.size.width, contactDataView.frame.size.height)];

    
    [mainScrollView addSubview:bookingButton];
    
    int xPos1;
    xPos1 = (self.view.bounds.size.width - bookingButton.frame.size.width) / 2;
    [bookingButton setFrame:CGRectMake(xPos1, CGRectGetMaxY(extraFacilitiesView.frame) + 25, bookingButton.frame.size.width, bookingButton.frame.size.height)];
    
    
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
    if([[UIScreen mainScreen] bounds].size.height > 480 ){
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height+25)];
    }
    else{
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height + 25)]; // iphone 4
    }
    
    //ComNSLog(@"facilities text view delegate---%@", extraFacilitiesTextView.delegate);
    
    noOfAdults = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    noOfChildren = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    dropDownOptions= @[@"0 camere",@"1 camera",@"2 camere",@"3 camere",@"4 camere",@"5 camere",@"6 camere",@"7 camere",@"8 camere",@"9 camere",@"10 camere"];
    
    
    // drop down camere
    [self.view addSubview:dropDownView];
    
    [dropDownTableView setFrame:CGRectMake(dropDownTableView.frame.origin.x,dropDownTableView.frame.origin.y , dropDownTableView.frame.size.width, 49 * [dropDownOptions count] + dropDownTableView.frame.origin.y)];
    
    
    int xPos, yPos;
    xPos = 20;//(self.view.bounds.size.width - 250) /2;
    yPos = (self.view.bounds.size.height - dropDownView.frame.size.height) /2;
    
    [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
    
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableView.frame.size.height + dropDownTableView.frame.origin.y)];
    
    UIView * separatorViewR;
    for(UIView * mView in dropDownView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    separatorViewR = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(roomDropDownLabel.frame),dropDownTableView.frame.size.width, 0.5)];
    [separatorViewR setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorViewR setTag:666];
    
    separatorViewR.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [adultDropDownView addSubview:separatorViewR];
    
    
    //ComNSLog(@"separator view r fr:   %@",NSStringFromCGRect(separatorViewR.frame));
    [hideView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    
    
    //drop down adulti
    
    [self.view addSubview:adultDropDownView];
    
    [adultDropDownTableView setFrame:CGRectMake(adultDropDownTableView.frame.origin.x,adultDropDownTableView.frame.origin.y , adultDropDownTableView.frame.size.width, 49 * [noOfAdults count] + adultDropDownTableView.frame.origin.y)];
    
    
    int xPosA, yPosA;
    xPosA = 20;
    yPosA = (self.view.bounds.size.height - adultDropDownView.frame.size.height) /2;
    
    [adultDropDownView setFrame:CGRectMake(xPosA, yPosA, self.view.bounds.size.width -40, adultDropDownView.frame.size.height)];
    
    [adultDropDownScrollView setContentSize:CGSizeMake(adultDropDownView.frame.size.width, adultDropDownTableView.frame.size.height + adultDropDownTableView.frame.origin.y)];
    
    UIView * separatorViewA;
    for(UIView * mView in adultDropDownView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    separatorViewA = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(adultDropDownLabel.frame),adultDropDownTableView.frame.size.width, 0.5)];
    [separatorViewA setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorViewA setTag:666];
    
    separatorViewA.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [adultDropDownView addSubview:separatorViewA];
    //drop down copii
    
    [self.view addSubview:childrenDropDownView];
    
    [childrenDropDownTableView setFrame:CGRectMake(childrenDropDownTableView.frame.origin.x,childrenDropDownTableView.frame.origin.y , childrenDropDownTableView.frame.size.width, 49 * [noOfChildren count] + childrenDropDownTableView.frame.origin.y)];
    
    
    int xPosC, yPosC;
    xPosC = 20; //(self.view.frame.size.width - childrenDropDownView.frame.size.width) /2;
    yPosC = (self.view.bounds.size.height - childrenDropDownView.frame.size.height) /2;
    
    [childrenDropDownView setFrame:CGRectMake(xPosC, yPosC, self.view.bounds.size.width -40, childrenDropDownView.frame.size.height)];
    
    [childrenDropDownScrollView setContentSize:CGSizeMake(childrenDropDownView.frame.size.width, childrenDropDownTableView.frame.size.height + childrenDropDownTableView.frame.origin.y)];
    
    
    UIView * separatorViewC;
    for(UIView * mView in childrenDropDownView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    separatorViewC = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(childreanDropDownLabel.frame),childrenDropDownTableView.frame.size.width, 0.5)];
    [separatorViewC setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorViewC setTag:666];
    
    separatorViewC.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [childrenDropDownView addSubview:separatorViewC];
    
    //dropDown data
    
    [self.view addSubview:dateDropDownView];
    int xPosD, yPosD;
    xPosD = 20;//(self.view.frame.size.width - dateDropDownView.frame.size.width) /2;
    yPosD = (self.view.bounds.size.height - dateDropDownView.frame.size.height) /2;
    
    [dateDropDownView setFrame:CGRectMake(xPosC, yPosC, self.view.bounds.size.width -40, dateDropDownView.frame.size.height)];
    
    UIView * separatorViewD;
    for(UIView * mView in dateDropDownView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    separatorViewD = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(dateDropDownLabel.frame),dateDropDownView.frame.size.width, 0.5)];
    [separatorViewD setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorViewD setTag:666];
    
    separatorViewD.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [dateDropDownView addSubview:separatorViewD];
    
//    [dateDropDownScrollView setContentSize:CGSizeMake(dateDropDownView.frame.size.width, dateDropDownTableView.frame.size.height + tableDateDropDown.frame.origin.y)];
    
    
    //adauga recognizer pt selectare numar de adulti si copii
    
    UITapGestureRecognizer * recognA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseNumberOfAdults:)];
    [adultBigView addGestureRecognizer:recognA];
    
    UITapGestureRecognizer * recognC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseNumberOfChildren:)];
    [childrenBigView addGestureRecognizer:recognC];
    
    
    [hideView setHidden:YES];
    [dropDownView setHidden:YES];
    [adultDropDownView setHidden:YES];
    [childrenDropDownView setHidden:YES];
    [dateDropDownView setHidden:YES];
    
    [mainScrollView bringSubviewToFront:hideView];
    
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
    
    

    [selectRoomsTitleLabel setTextColor:UIColorFromRGB(0x666666)];
    UIFont* italicFont = [UIFont fontWithName:@"OpenSansLight-Italic" size:17.5f];
    
    
    [touristName setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    [touristMail setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    [touristPhone setValue:italicFont forKeyPath:@"_placeholderLabel.font"];
    
    touristName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    touristMail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    touristPhone.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [touristPhone setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [touristPhone setTextColor:UIColorFromRGB(0x666666)];

    
    [touristName setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [touristName setTextColor:UIColorFromRGB(0x666666)];
    
    [touristMail setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [touristMail setTextColor:UIColorFromRGB(0x666666)];
    
    // adauga recognizer pentru schimbat data
    
    UITapGestureRecognizer * fromrecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectStartDate:)];
    UITapGestureRecognizer *untilrecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEndDate:)];
    
    [startView addGestureRecognizer:fromrecogn];
    [endView addGestureRecognizer:untilrecogn];
    
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
    
    
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        //ComNSLog(@"from landscape");
        
        CGSize textViewSize = [self sizeOfText:extraFacilitiesTextView.text widthOfTextView:extraFacilitiesTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]];
        if(textViewSize.height < minimumSize.height){
            textViewSize = minimumSize;
        }
        
        extraFacilitiesTextView.contentInset = UIEdgeInsetsZero;
        extraFacilitiesTextView.showsHorizontalScrollIndicator = NO;
        extraFacilitiesTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        
        [extraFacilitiesTextView setFrame:CGRectMake(extraFacilitiesTextView.frame.origin.x, extraFacilitiesTextView.frame.origin.y, extraFacilitiesTextView.frame.size.width, textViewSize.height +8)];
        
        [extraFacilitiesView setFrame:CGRectMake(extraFacilitiesView.frame.origin.x, selectPeople.frame.origin.y + selectPeople.frame.size.height, extraFacilitiesView.frame.size.width, extraFacilitiesTextView.frame.origin.y + extraFacilitiesTextView.frame.size.height)];
        
        
//        [contactDataView setFrame:CGRectMake(contactDataView.frame.origin.x, extraFacilitiesView.frame.origin.y + extraFacilitiesView.frame.size.height, contactDataView.frame.size.width, contactDataView.frame.size.height)];
        
        [bookingButton setFrame:CGRectMake(bookingButton.frame.origin.x, CGRectGetMaxY(extraFacilitiesView.frame) + 25, bookingButton.frame.size.width, bookingButton.frame.size.height)];
        
        [mainScrollView setShowsHorizontalScrollIndicator:NO];
        [mainScrollView setShowsVerticalScrollIndicator:YES];
        
        if([[UIScreen mainScreen] bounds].size.height > 480 ){
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height + 25)];
        }
        else{
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height + 25)];
        }
        
        
    }
    else{
        //ComNSLog(@"from portrait");
        
        CGSize textViewSize = [self sizeOfText:extraFacilitiesTextView.text widthOfTextView:extraFacilitiesTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]];
        if(textViewSize.height < minimumSize.height){
            textViewSize = minimumSize;
        }
        
        extraFacilitiesTextView.contentInset = UIEdgeInsetsZero;
        extraFacilitiesTextView.showsHorizontalScrollIndicator = NO;
        extraFacilitiesTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        
        [extraFacilitiesTextView setFrame:CGRectMake(extraFacilitiesTextView.frame.origin.x, extraFacilitiesTextView.frame.origin.y, extraFacilitiesTextView.frame.size.width, textViewSize.height +8)];
        
        [extraFacilitiesView setFrame:CGRectMake(extraFacilitiesView.frame.origin.x, selectPeople.frame.origin.y + selectPeople.frame.size.height, extraFacilitiesView.frame.size.width, extraFacilitiesTextView.frame.origin.y + extraFacilitiesTextView.frame.size.height)];
        
        
//        [contactDataView setFrame:CGRectMake(contactDataView.frame.origin.x, extraFacilitiesView.frame.origin.y + extraFacilitiesView.frame.size.height, contactDataView.frame.size.width, contactDataView.frame.size.height)];
        
        [bookingButton setFrame:CGRectMake(bookingButton.frame.origin.x, CGRectGetMaxY(extraFacilitiesView.frame)+25, bookingButton.frame.size.width, bookingButton.frame.size.height)];
        
        [mainScrollView setShowsHorizontalScrollIndicator:NO];
        [mainScrollView setShowsVerticalScrollIndicator:YES];
        
        if([[UIScreen mainScreen] bounds].size.height > 480 ){
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height+25)];
        }
        else{
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height + 25)];
        }
        
    }

    
//    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing:)];
//    [mainScrollView addGestureRecognizer:gestureRecognizer];
    UITapGestureRecognizer * recogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDown:)];
    recogn.numberOfTapsRequired = 1;
    [hideView addGestureRecognizer:recogn];
    
    //ComNSLog(@"contact data frame---%@",NSStringFromCGRect(contactDataView.frame));
    //ComNSLog(@"extrafacilities frame---%@",NSStringFromCGRect(extraFacilitiesView.frame));
}

-(void)hideDropDown:(UITapGestureRecognizer *)recogn{
    [dropDownView setHidden:YES];
    [adultDropDownView setHidden:YES];
    [childrenDropDownView setHidden:YES];
    [dateDropDownView setHidden:YES];
    [hideView setHidden:YES];
}





-(void)selectStartDate:(UITapGestureRecognizer *)recognizer{
//    [startDatePicker setDate:startDateAux];
//    [hideView setHidden:NO];
//    [startDatePickerView setHidden:NO];
//    [self.view bringSubviewToFront:startDatePicker];
//    
//    
//    //ComNSLog(@"start date---%@", NSStringFromCGRect(startDatePicker.frame));
    [dateDropDownLabel setText:@"De la:"];
    [dateDropDownView setHidden:NO];
    [hideView setHidden:NO];
    dataArray = startDates;
    [tableDateDropDown setFrame:CGRectMake(tableDateDropDown.frame.origin.x,tableDateDropDown.frame.origin.y , tableDateDropDown.frame.size.width, 49 * [dataArray count] + tableDateDropDown.frame.origin.y)];
    [dateDropDownScrollView setContentSize:CGSizeMake(dateDropDownView.frame.size.width, tableDateDropDown.frame.size.height + tableDateDropDown.frame.origin.y + 49)];
    [tableDateDropDown setTag:STARTDATE];
    [tableDateDropDown reloadData];
    
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
    [dateDropDownLabel setText:@"Pana la:"];
    [dateDropDownView setHidden:NO];
    [hideView setHidden:NO];
    dataArray = endDates;
    [tableDateDropDown setFrame:CGRectMake(tableDateDropDown.frame.origin.x,tableDateDropDown.frame.origin.y , tableDateDropDown.frame.size.width, 49 * [dataArray count] + tableDateDropDown.frame.origin.y)];
    [dateDropDownScrollView setContentSize:CGSizeMake(dateDropDownView.frame.size.width, tableDateDropDown.frame.size.height + tableDateDropDown.frame.origin.y + 49)];
    [tableDateDropDown setTag:ENDDATE];
    [tableDateDropDown reloadData];
    
}

-(void)chooseNumberOfAdults:(UITapGestureRecognizer *)recognizer{
    [mainScrollView bringSubviewToFront:hideView];
    [self.view bringSubviewToFront:adultDropDownView];
    [hideView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [hideView setHidden:NO];
    [adultDropDownView setHidden:NO];
    
    int number = [adultLabel.text intValue] -1;
    
    DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [adultDropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:number inSection:0]];
    
    for(int i = 0; i< [dropDownTableView numberOfRowsInSection:0]; i++){
        if(i != number){
            DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [adultDropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
            [dropCell.checkImage setHidden:YES];
        }
    }
    
    [dropCell.checkImage setHidden:NO];
    [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
    
//    feeIndex = indexPath.row;

}

-(void)chooseNumberOfChildren:(UITapGestureRecognizer *)recognizer{
    [mainScrollView bringSubviewToFront:hideView];
    [self.view bringSubviewToFront:childrenDropDownView];
    [hideView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [hideView setHidden:NO];
    [childrenDropDownView setHidden:NO];
    
    int number = [childrenLabel.text intValue];
    
    DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [childrenDropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:number inSection:0]];
    
    for(int i = 0; i< [childrenDropDownTableView numberOfRowsInSection:0]; i++){
        if(i != number){
            DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [childrenDropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
            [dropCell.checkImage setHidden:YES];
        }
    }
    
    [dropCell.checkImage setHidden:NO];
    [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //ComNSLog(@"textview did begin editing");
}

-(void)textViewDidChange:(UITextView *)textView{
    //ComNSLog(@" textview did change");
    CGSize textViewSize = [self sizeOfText:extraFacilitiesTextView.text widthOfTextView:extraFacilitiesTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]];
    if(textViewSize.height < minimumSize.height){
        textViewSize = minimumSize;
    }
    
    extraFacilitiesTextView.contentInset = UIEdgeInsetsZero;
    extraFacilitiesTextView.showsHorizontalScrollIndicator = NO;
    extraFacilitiesTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    
    [extraFacilitiesTextView setFrame:CGRectMake(extraFacilitiesTextView.frame.origin.x, extraFacilitiesTextView.frame.origin.y, extraFacilitiesTextView.frame.size.width, textViewSize.height +8)];
    
    [extraFacilitiesView setFrame:CGRectMake(extraFacilitiesView.frame.origin.x, selectPeople.frame.origin.y + selectPeople.frame.size.height, extraFacilitiesView.frame.size.width, extraFacilitiesTextView.frame.origin.y + extraFacilitiesTextView.frame.size.height)];
    
    
//    [contactDataView setFrame:CGRectMake(contactDataView.frame.origin.x, extraFacilitiesView.frame.origin.y + extraFacilitiesView.frame.size.height, contactDataView.frame.size.width, contactDataView.frame.size.height)];
    
    [bookingButton setFrame:CGRectMake(bookingButton.frame.origin.x, CGRectGetMaxY(extraFacilitiesView.frame) + 25, bookingButton.frame.size.width, bookingButton.frame.size.height)];
    
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
    if([[UIScreen mainScreen] bounds].size.height > 480 ){
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height+25)];
    }
    else{
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bookingButton.frame.origin.y + bookingButton.frame.size.height + 25)];
    }
    
   

}



-(void)textViewDidEndEditing:(UITextView *)textView{
    //ComNSLog(@"textview end editing");
}


-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    //ComNSLog(@"text to measure---%@,%f,%@",textToMesure,width,font);
    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == feesTableView){
        static NSString *CellIdentifier = @"FeeTableViewCell";
        FeeTableViewCell *cell = (FeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FeeTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (FeeTableViewCell *) currentObject;
                    break;
                }
            }
        }
        
        [cell.iconView setImage:[UIImage imageNamed:room_icons[feesArray[indexPath.row][@"icon"]]]];
        
        [cell.roomPriceLabel setText:[NSString stringWithFormat:@"%@ %@",feesArray[indexPath.row][@"suma"], feesArray[indexPath.row][@"moneda"]]];
        
        [cell.numberOfRoomsLabel setText:roomsSelectionArray[indexPath.row]];
        [cell.numberOfRoomsView setTag:indexPath.row];
        
        [cell.roomPriceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
        
        [cell.roomPriceLabel setTextColor:UIColorFromRGB(0x666666)];
        
        
        [cell.numberOfRoomsLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
        [cell.numberOfRoomsLabel setTextColor:UIColorFromRGB(0x666666)];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;

    }
    else{
        if(tableView == dropDownTableView){
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
            
            [cell.noOfRooms setText:dropDownOptions[indexPath.row]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIView * separatorView;
            for(UIView * mView in cell.contentView.subviews){
                if(mView.tag == 666){
                    [mView removeFromSuperview];
                }
            }
            
            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,49 - 0.5 ,dropDownTableView.frame.size.width, 0.5)];
            [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
            [separatorView setTag:666];
            separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:separatorView];
            
            
            return cell;

        }
        else{
            if(tableView == adultDropDownTableView){
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
                
                [cell.noOfRooms setText:[NSString stringWithFormat:@"%d",[noOfAdults[indexPath.row ] intValue]]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                UIView * separatorView;
                for(UIView * mView in cell.contentView.subviews){
                    if(mView.tag == 666){
                        [mView removeFromSuperview];
                    }
                }
                
                separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,49 - 0.5 ,dropDownTableView.frame.size.width, 0.5)];
                [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
                [separatorView setTag:666];
                 separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                [cell.contentView addSubview:separatorView];
                
                return cell;

            }
            else{
                if(tableView == tableDateDropDown){
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
                    
                    separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,49 - 0.5 ,dropDownTableView.frame.size.width, 0.5)];
                    [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
                    [separatorView setTag:666];
                    separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                    [cell.contentView addSubview:separatorView];
                    
                    return cell;

                }
                else{
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
                    
                    [cell.noOfRooms setText:noOfChildren[indexPath.row]];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    UIView * separatorView;
                    for(UIView * mView in cell.contentView.subviews){
                        if(mView.tag == 666){
                            [mView removeFromSuperview];
                        }
                    }
                    
                    separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,49 - 0.5 ,dropDownTableView.frame.size.width, 0.5)];
                    [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
                    [separatorView setTag:666];
                    separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;                    
                    [cell.contentView addSubview:separatorView];
                    
                    return cell;

                }
                
            }
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == dropDownTableView){
        DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        for(int i = 0; i< [tableView numberOfRowsInSection:0]; i++){
            if(i != indexPath.row){
                DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
                [cell.checkImage setHidden:YES];
            }
        }
        
        [cell.checkImage setHidden:NO];
        [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
        numberOfRooms = indexPath.row;
        
        [self dropDownSelectFunction:feeIndex andIdCateg:0];
    }
    else{
        if(tableView == feesTableView){
            //ComNSLog(@"did select----%d",[dropDownTableView numberOfRowsInSection:0]);
            [mainScrollView bringSubviewToFront:hideView];
            [self.view bringSubviewToFront:dropDownView];
            [hideView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
            [hideView setHidden:NO];
            [dropDownView setHidden:NO];
            FeeTableViewCell * cell = (FeeTableViewCell *)[feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            NSString * temp = cell.numberOfRoomsLabel.text;
            NSArray * tempArray = [temp componentsSeparatedByString:@" "];
            int number = [tempArray[0] intValue];
            
            DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [dropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:number inSection:0]];
            
            for(int i = 0; i< [dropDownTableView numberOfRowsInSection:0]; i++){
                if(i != number){
                    DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [dropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
                    [dropCell.checkImage setHidden:YES];
                }
            }
            
            [dropCell.checkImage setHidden:NO];
            [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
            
            feeIndex = indexPath.row;
            
            //ComNSLog(@"hide view drop down view---%d,%d",hideView.isHidden, dropDownView.isHidden);
            

        }
        else{
            if(tableView == adultDropDownTableView){
                DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
                
                for(int i = 0; i< [tableView numberOfRowsInSection:0]; i++){
                    if(i != indexPath.row +1){
                        DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
                        [cell.checkImage setHidden:YES];
                    }
                }
                
                [cell.checkImage setHidden:NO];
                [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
                numberOfRooms = indexPath.row +1;
                
                
                [self dropDownSelectFunction:feeIndex andIdCateg:1];
            }
            else{
                if (tableView == tableDateDropDown) {
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
                    
                    [dateDropDownView setHidden:YES];
                    auxnumber = indexPath.row;
                    [self dropDownSelectFunctionCateg:tableView.tag];
                }
                else{
                    DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
                    
                    for(int i = 0; i< [tableView numberOfRowsInSection:0]; i++){
                        if(i != indexPath.row){
                            DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                            [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
                            [cell.checkImage setHidden:YES];
                        }
                    }
                    
                    [cell.checkImage setHidden:NO];
                    [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
                    numberOfRooms = indexPath.row;
                    
                    [self dropDownSelectFunction:feeIndex andIdCateg:2];
                }
                
            }
        }
    }

}

-(void)dropDownSelectFunctionCateg:(int)idCateg{
    
    switch (idCateg) {
        case STARTDATE:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            
            NSArray * dateArray = [startDates[auxnumber] componentsSeparatedByString:@","];
            
            NSString * myTempStr = [NSString stringWithFormat:@"%@",dateArray[1]];
            [startDateLabel setText:myTempStr];
            //            [startDateLabel setText:];
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MM yyyy"];
            NSString *temp = myTempStr;

            NSArray * tempArray = [temp componentsSeparatedByString:@" "];
            int monthDay = [months indexOfObject:tempArray[1]] +1;
            NSString * formattedDate = [@[tempArray[0],[NSString stringWithFormat:@"%d",monthDay],tempArray[2]] componentsJoinedByString:@" "];
            //ComNSLog(@"formatted date---%@", formattedDate);
            startDateAux = [formatter dateFromString:formattedDate];
            //ComNSLog(@"start date aux---%@",startDateAux);
            //[endDates removeAllObjects];
//            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//            dayComponent.day = 1;
//            NSCalendar *theCalendar = [NSCalendar currentCalendar];
//            
//            
//            for(int i=1; i<15; i++){
//                NSDate *tempDate = startDateAux;
//                
//                dayComponent.day = i;
//                tempDate = [theCalendar dateByAddingComponents:dayComponent toDate:tempDate options:0];
//                
//                NSArray * tempStringArray = [[formatter stringFromDate:tempDate] componentsSeparatedByString:@" "];
//                
//                NSString * tempMonth = months[[tempStringArray[1] intValue]-1];
//                
//                NSString *tempDateString = [NSString stringWithFormat:@"%@ %@ %@",tempStringArray[0], tempMonth, tempStringArray[2]];
//                
//                
//                [endDates addObject:tempDateString];
//            }
//            
//            dayComponent.day =1;
//            //ComNSLog(@"compare---%d",[startDate compare:startDateAux]);
            
            
            
            //ComNSLog(@"end dates---%@",endDates);
//            [selectedRows setObject:[NSNumber numberWithInteger:0] atIndexedSubscript:ENDDATE];
//            [endDateLabel setText:[NSString stringWithFormat:@"%@",endDates[0]]];
            // }
            
            
            break;
        }
        case ENDDATE:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
           // [endDateLabel setText:endDates[auxnumber]];
            NSArray * dateArray = [endDates[auxnumber] componentsSeparatedByString:@","];
            
            [endDateLabel setText:[NSString stringWithFormat:@"%@",dateArray[1]]];
            break;
        }
            
            
            
        default:
            break;
    }
    
    
}


-(void)dropDownSelectFunction:(int)index andIdCateg:(int)idCateg{
    
    switch (idCateg) {
        case 0:{
            [hideView setHidden:YES];
            [dropDownView setHidden:YES];
            FeeTableViewCell * cell = (FeeTableViewCell *)[feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:feeIndex inSection:0]];
            [cell.numberOfRoomsLabel setText:[NSString stringWithFormat:@"%d camere",numberOfRooms]];
            break;
        }
        case 1:{
            [hideView setHidden:YES];
            [adultDropDownView setHidden:YES];
//            FeeTableViewCell * cell = (FeeTableViewCell *)[feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:feeIndex inSection:0]];
//            [cell.numberOfRoomsLabel setText:[NSString stringWithFormat:@"%d camere",numberOfRooms]];
            
            [adultLabel setText:[NSString stringWithFormat:@"%d",numberOfRooms]];
            
            break;
        }
        case 2:{
            [hideView setHidden:YES];
            [childrenDropDownView setHidden:YES];
//            FeeTableViewCell * cell = (FeeTableViewCell *)[feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:feeIndex inSection:0]];
//            [cell.numberOfRoomsLabel setText:[NSString stringWithFormat:@"%d camere",numberOfRooms]];
            
            [childrenLabel setText:[NSString stringWithFormat:@"%d",numberOfRooms]];
            break;
        }
            
            
            
        default:
            break;
    }
    

}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //ComNSLog(@"textview should begin editing");
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == feesTableView){
        return [feesArray count];
    }
    else{
        if(tableView == dropDownTableView){
           return  [dropDownOptions count];
        }
        else{
            if(tableView == adultDropDownTableView){
               return [noOfAdults count];
            }
            else{
                if(tableView == tableDateDropDown){
                    return [dataArray count];
                }
                else return [noOfChildren count];
            }
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == feesTableView){
        return 49;
    }
    else{
        return 49;
    }
}


-(IBAction)backAction:(UIButton *)backButton{
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
    
    //ComNSLog(@"START DATE STRING:  %@", startDateString);
    //ComNSLog(@"END DATE STRING:    %@", endDateString);
    
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

-(IBAction)bookingRequest:(UIButton *)sender{
   
//    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:@[@{@"type":[NSNumber numberWithInt:0], @"text":@"Numele introdus"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Adresa de email introdusa"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Numarul de telefon introdus"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Numarul de camere ales"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Numarul de adulti ales"},@{@"type":[NSNumber numberWithInt:0], @"text":@"Suma alocata"}]];
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM yyyy"];
    
    NSString * temp = startDateLabel.text;
    //NSArray * tempArray = [temp componentsSeparatedByString:@","];
    NSString *startTemp = [temp stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
    NSArray * startTempArray = [startTemp componentsSeparatedByString:@" "];
    //ComNSLog(@"start temp arr ---%@", startTempArray);
    int monthDay = [months indexOfObject:startTempArray[1]] +1;
    NSString * formattedDate = [@[startTempArray[0],[NSString stringWithFormat:@"%d",monthDay],startTempArray[2]] componentsJoinedByString:@" "];
    
    NSDate *mStartDate = [formatter dateFromString:formattedDate];
    
    
    
    NSString * temp1 = endDateLabel.text;
   // NSArray * temp1Array = [temp1 componentsSeparatedByString:@","];
    NSString *endTemp = [temp1 stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
    
    NSArray *endTempArray = [endTemp componentsSeparatedByString:@" "];
    //ComNSLog(@"end temp arr ---%@", endTempArray);
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
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:@[@{@"type":[NSNumber numberWithInt:0], @"text1":@"Numele trebuie completat",@"text2":@"Numele introdus este invalid"},@{@"type":[NSNumber numberWithInt:0], @"text2":@"Adresa de email introdusa este invalida", @"text1":@"Adresa de email trebuie introdusa"},@{@"type":[NSNumber numberWithInt:0], @"text2":@"Numarul de telefon introdus este invalid", @"text1":@"Numarul de telefon trebuie completat"},@{@"type":[NSNumber numberWithInt:0], @"text1":@"Numarul de camere trebuie completat",@"text2":@""}]];
            
            
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
            
            NSMutableArray * roomsArray = [[NSMutableArray alloc] init];
            
            int countRooms = 0;
            for(int i=0; i< [feesArray count]; i++){
                FeeTableViewCell * cell = (FeeTableViewCell *)[feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                //ComNSLog(@"room----%@, %@", cell.numberOfRoomsLabel.text, feesArray[i][@"idCamera"]);
                NSDictionary * tempDict = @{@"id":feesArray[i][@"idCamera"],@"nr":[NSNumber numberWithInt:[[cell.numberOfRoomsLabel.text componentsSeparatedByString:@" "][0] intValue]]};
                [roomsArray addObject:tempDict];
                countRooms += [[cell.numberOfRoomsLabel.text componentsSeparatedByString:@" "][0] intValue];
            }
            
            //ComNSLog(@"rooms array:   %@", roomsArray);
//            if(!countRooms){
//                NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[3]];
//                [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
//                [tempArray setObject:dict atIndexedSubscript:3];
//            }
//            
            
            //    int numberOfAdults = [adultLabel.text intValue];
            
            //    if(numberOfAdults){
            //        NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[4]];
            //        [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
            //        [tempArray setObject:dict atIndexedSubscript:4];
            //    }
            
            
            int numberOfChildrean = [childrenLabel.text intValue];
            
//            if(numberOfChildrean){
//                NSMutableDictionary * dict = [[NSMutableDictionary alloc]  initWithDictionary:tempArray[5]];
//                [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
//                [tempArray setObject:dict atIndexedSubscript:5];
//            }
            
             int numberOfAdults = [adultLabel.text intValue];
            
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
            
//            numberOfAdults = 1;
//            numberOfChildrean = 2;
            //ComNSLog(@"adults: %d, childs: %d", numberOfAdults, numberOfChildrean);
            
            if(str.length == 0){
                
                MKNetworkEngine *engine;    //engine de request web get post
                engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
                NSString *path_proces = [[NSString alloc]init];
                path_proces =@"/app_cr/rezervare/?id=myx1j3";
                
                // NSString * str = [NSString stringWithFormat:@"[{id:2579,nr:2},{id:1563,nr:0}]"];
                
//                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{@"idPensiune":myJson[@"id"],@"deLa":[NSNumber numberWithDouble:[mStartDate timeIntervalSince1970]], @"panaLa":[NSNumber numberWithDouble:[mEndDate timeIntervalSince1970]],@"nume":touristName.text,@"email":touristMail.text,@"telefon":touristPhone.text,@"cerinte":extraFacilitiesTextView.text,@"adulti":[NSNumber numberWithInt:numberOfAdults],@"copii":[NSNumber numberWithInt:numberOfChildrean],@"camere":roomsArray}];
                
                
                NSString * str = @"[";
                
                for(int i =0; i< [roomsArray count] -1; i++){
                    str = [str stringByAppendingFormat:@"{id:%@,nr:%@},",roomsArray[i][@"id"],roomsArray[i][@"nr"]];
                }
                str = [str stringByAppendingFormat:@"{id:%@,nr:%@}]",roomsArray[[roomsArray count] -1][@"id"],roomsArray[[roomsArray count] -1][@"nr"]];
                
                //ComNSLog(@"str str:   %@",str);
                
                //ComNSLog(@"adulti:  %d",numberOfAdults);
                
                NSMutableDictionary * param2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:myJson[@"id"],@"idPensiune"
                                                ,[NSNumber numberWithDouble:[mStartDate timeIntervalSince1970]],@"deLa",
                                                  [NSNumber numberWithDouble:[mEndDate timeIntervalSince1970]],@"panaLa",
                                                    touristName.text,@"nume",
                                                    touristMail.text,@"email",
                                                    touristPhone.text,@"telefon",
                                                    extraFacilitiesTextView.text,@"cerinte",
                                                    [NSNumber numberWithInt:numberOfAdults], @"adulti",
                                                [NSNumber numberWithInt:numberOfChildrean], @"copii",
                                                roomsArray ,@"camere",
                                                nil];

                MKNetworkOperation *op = [engine operationWithPath:path_proces
                                                            params:param2
                                                        httpMethod:@"POST"];
                
                
                op.postDataEncoding = MKNKPostDataEncodingTypeURL;
                
                //ComNSLog(@"param2:  %@",param2);
                [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                    //NSData *rezultat_REQ4 = [completedOperation responseData];
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
        transition.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:transition forKey:nil];
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

    if (text.length==10 && isValid )
    {
        //ComNSLog(@"text:    %@",[text substringToIndex:1]);
        if([[text substringToIndex:1] isEqualToString:@"0"]){
           isValid = YES;
        }
        else{
            isValid = NO;
        }
        
    }
    else
    {
        if(text.length > 10){
            NSString * firstPart = [text substringWithRange:NSMakeRange(0, [text length] -10)];
            NSString * secondPart = [text substringWithRange:NSMakeRange(firstPart.length, 10)];
            
            //ComNSLog(@"first part---%@",firstPart);
            //ComNSLog(@"second part---%@",secondPart);

            NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:secondPart];
            isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
            if (secondPart.length==10 && isValid )
            {
                if([[secondPart substringToIndex:1] isEqualToString:@"0"] &&  [firstPart isEqualToString:@"+4"]){
                    isValid = YES;
                }
                else{
                    isValid = NO;
                }
                
            }
        }
        else{
          isValid=NO;
        }
        
    }
    
    
   
    return isValid;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
