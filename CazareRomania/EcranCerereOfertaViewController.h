//
//  EcranCerereOfertaViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 14/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface EcranCerereOfertaViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    CGSize minimumSize;
    NSArray *months, *adults, *childrean, *currency, *cost_type, *dataArray, *rooms, *weekDays;
    NSMutableArray *selectedRows;
    NSDate *startDateAux, *endDateAux;
    int auxnumber;
    NSMutableArray *startDates;
    NSMutableArray *endDates;
    NSDate *startDate;
    NSArray *myJson;
    NSMutableArray * idsPensiuni;
}

@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIButton *cancelButton;
@property(nonatomic, strong) IBOutlet UITextView *warningMessage;
@property(nonatomic, strong) IBOutlet UITextField *touristName;
@property(nonatomic, strong) IBOutlet UITextField *touristMail;
@property(nonatomic, strong) IBOutlet UITextField *touristPhone;
@property(nonatomic, strong) IBOutlet UIView *touristView;
@property(nonatomic, strong) IBOutlet UIView *selectDateView;
@property(nonatomic, strong) IBOutlet UISwitch *flexibleDates;
@property(nonatomic, strong) IBOutlet UILabel *startDateLabel;
@property(nonatomic, strong) IBOutlet UILabel *endDateLabel;
@property(nonatomic, strong) IBOutlet UIView *selectRoomsView;
@property(nonatomic, strong) IBOutlet UILabel *selectRoomsLabel;
@property(nonatomic, strong) IBOutlet UIView *selectAdultsView;
@property(nonatomic, strong) IBOutlet UILabel *selectAdultsLabel;
@property(nonatomic, strong) IBOutlet UIView *selectChildreanView;
@property(nonatomic, strong) IBOutlet UILabel *selectChildreanLabel;
@property(nonatomic, strong) IBOutlet UITextField *totalCost;
@property(nonatomic, strong) IBOutlet UIView *currencyView;
@property(nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property(nonatomic, strong) IBOutlet UILabel *costTypeLabel;
@property(nonatomic, strong) IBOutlet UIView *costTypeVIew;
@property(nonatomic, strong) IBOutlet UIView *budgetView;
@property(nonatomic, strong) IBOutlet UIView *selectRoomsAndPeopleView;
@property(nonatomic, strong) IBOutlet UIView *otherView;
@property(nonatomic, strong) IBOutlet UITextView *otherTextView;
@property(nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property(nonatomic, strong) IBOutlet UIView *costLabelParentView;
@property(nonatomic, strong) IBOutlet UIView *roomsLabelParentView;
@property(nonatomic, strong) IBOutlet UIView *adultsLabelParentView;
@property(nonatomic, strong) IBOutlet UIView *childreanLabelParentView;
@property(nonatomic, strong) IBOutlet UIView *startDatePickerView;
@property(nonatomic, strong) IBOutlet UIView *endDatePickerView;
@property(nonatomic, strong) IBOutlet UIDatePicker *startDatePicker;
@property(nonatomic, strong) IBOutlet UIDatePicker *endDatePicker;
@property(nonatomic, strong) IBOutlet UIButton *cancelStartDate;
@property(nonatomic, strong) IBOutlet UIButton *cancelEndDate;
@property(nonatomic, strong) IBOutlet UIButton *chooseStartDate;
@property(nonatomic, strong) IBOutlet UIButton *chooseEndDate;
@property(nonatomic, strong) IBOutlet UIView *hideView;
@property(nonatomic, strong) IBOutlet UIView *startDateParentView;
@property(nonatomic, strong) IBOutlet UIView *endDateParentView;
@property(nonatomic, strong) IBOutlet UIView *dropDownView;
@property(nonatomic, strong) IBOutlet UITableView *dropDownTableVIew;
@property(nonatomic, strong) IBOutlet UIScrollView *dropDownScrollView;
@property(nonatomic, strong) IBOutlet UIButton * sendButton;
@property(nonatomic, strong) IBOutlet UILabel * dropDownLabel;
@property(nonatomic, strong) IBOutlet UIButton * switchBtn;

@property(nonatomic, strong) IBOutlet UILabel * selectRoomsTitleLabel;
@property(nonatomic, strong) IBOutlet UIView * dateSep1;
@property(nonatomic, strong) IBOutlet UIView * dateSep2;
@property(nonatomic, strong) IBOutlet UIView * dateSep3;
@property(nonatomic, strong) IBOutlet UIView * dateSep4;
@property(nonatomic, strong) IBOutlet UIView * dateSep5;


@property(nonatomic, strong) IBOutlet UILabel * startLabel;
@property(nonatomic, strong) IBOutlet UILabel * endLabel;
@property(nonatomic, strong) IBOutlet UILabel * flexibleLabel;


@property(nonatomic, strong) IBOutlet UILabel * roomsLabel;
@property(nonatomic, strong) IBOutlet UILabel * adultsLabel;
@property(nonatomic, strong) IBOutlet UILabel * childreanLabel;
@property(nonatomic, strong) IBOutlet UILabel * budget;


@property(nonatomic, strong) IBOutlet UIView * sepRoom;
@property(nonatomic, strong) IBOutlet UIView * sepAdults;
@property(nonatomic, strong) IBOutlet UIView * sepChildrean;

@property(nonatomic, strong) IBOutlet UILabel * otherReqLabel;

@property(nonatomic, strong) IBOutlet UIView * sepSelectGroup;
@property(nonatomic, strong) IBOutlet UIView * sepSelectCurrency;

@property(nonatomic, strong) IBOutlet UIView * greenBorder;

@property(nonatomic, strong) IBOutlet UILabel * screenTitle;
@property (nonatomic, strong) NSArray * myJson;

//muta contitnutul scrollview-ului in functie de contentul 
-(void)moveForms;

@end
