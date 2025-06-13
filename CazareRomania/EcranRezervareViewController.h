//
//  EcranRezervareViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 13/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface EcranRezervareViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate, UIAlertViewDelegate>{
    NSArray *feesArray, *dropDownOptions, *noOfAdults, *noOfChildren, *months, *weekDays;
    int numberOfRooms, feeIndex;
    NSDate *startDateAux, *endDateAux;
    NSDictionary *myJson;
    CGSize minimumSize;
    NSMutableArray * roomsSelectionArray, *startDates, *endDates, *dataArray, *selectedRows;
    int auxnumber;
    NSDate *startDate;
    NSDictionary * room_icons;
}

@property(nonatomic, strong) IBOutlet UIView * backView;
@property(nonatomic, strong) IBOutlet UIButton * backButton;
@property(nonatomic, strong) IBOutlet UILabel * backLabel;
@property(nonatomic, strong) IBOutlet UILabel * nameLabel;
@property(nonatomic, strong) IBOutlet UILabel * locationLabel;
@property(nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic, strong) IBOutlet UILabel * startDateLabel;
@property(nonatomic, strong) IBOutlet UILabel * endDateLabel;
@property(nonatomic, strong) IBOutlet UIView * startView;
@property(nonatomic, strong) IBOutlet UIView * endView;
@property(nonatomic, strong) IBOutlet UIView * selectDateView;
@property(nonatomic, strong) IBOutlet UIView * selectRoomsView;
@property(nonatomic, strong) IBOutlet UITableView * feesTableView;
@property(nonatomic, strong) IBOutlet UIView * selectPeople;
@property(nonatomic, strong) IBOutlet UILabel * adultLabel;
@property(nonatomic, strong) IBOutlet UILabel * childrenLabel;
@property(nonatomic, strong) IBOutlet UIView * adultView;
@property(nonatomic, strong) IBOutlet UIView * childrenView;
@property(nonatomic, strong) IBOutlet UIView * extraFacilitiesView;
@property(nonatomic, strong) IBOutlet UITextView * extraFacilitiesTextView;
@property(nonatomic, strong) IBOutlet UIView * contactDataView;
@property(nonatomic, strong) IBOutlet UITextField * touristName;
@property(nonatomic, strong) IBOutlet UITextField * touristMail;
@property(nonatomic, strong) IBOutlet UITextField * touristPhone;
@property(nonatomic, strong) IBOutlet UIButton * bookingButton;
@property(nonatomic, strong) IBOutlet UILabel * extraFacilitiesLabel;
@property (nonatomic, strong) IBOutlet UIView * dropDownView;
@property (nonatomic, strong) IBOutlet UITableView *dropDownTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *dropDownScrollView;
@property (nonatomic, strong) IBOutlet UIView * hideView;
@property (nonatomic, strong) IBOutlet UIView * adultDropDownView;
@property (nonatomic, strong) IBOutlet UITableView *adultDropDownTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *adultDropDownScrollView;
@property (nonatomic, strong) IBOutlet UIView * childrenDropDownView;
@property (nonatomic, strong) IBOutlet UITableView * childrenDropDownTableView;
@property (nonatomic, strong) IBOutlet UIScrollView * childrenDropDownScrollView;
@property (nonatomic, strong) IBOutlet UIView * adultBigView;
@property (nonatomic, strong) IBOutlet UIView * childrenBigView;
@property (nonatomic, strong) IBOutlet UIDatePicker *startDatePicker;
@property (nonatomic, strong) IBOutlet UIDatePicker *endDatePicker;
@property (nonatomic, strong) IBOutlet UIView *startDatePickerView;
@property (nonatomic, strong) IBOutlet UIView *endDatePickerView;
@property (nonatomic, strong) IBOutlet UIButton *startDateDoneButton;
@property (nonatomic, strong) IBOutlet UIButton *endDateDoneButton;
@property (nonatomic, strong) NSDictionary * myJson;
@property (nonatomic, strong) NSMutableArray * roomsSelectionArray;
@property (nonatomic, strong) IBOutlet UIView * dateDropDownView;
@property (nonatomic, strong) IBOutlet UITableView * tableDateDropDown;
@property (nonatomic,strong) IBOutlet UIScrollView * dateDropDownScrollView;
@property (nonatomic, strong) IBOutlet UILabel * dateDropDownLabel;
@property (nonatomic, strong) IBOutlet UILabel * pageTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel * selectDateTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel * selectRoomsTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel * otherRequirementsLabel;
@property (nonatomic, strong) IBOutlet UILabel * adultsLabel;
@property (nonatomic, strong) IBOutlet UILabel * childreanLabel;
@property (nonatomic, strong) IBOutlet UILabel * startLabel;
@property (nonatomic, strong) IBOutlet UILabel * endLabel;
@property (nonatomic, strong) IBOutlet UIView * sepAdults;
@property (nonatomic, strong) IBOutlet UIView * sepChildrean;
@property (nonatomic, strong) IBOutlet UIView * dateSep1;
@property (nonatomic, strong) IBOutlet UIView * dateSep2;
@property (nonatomic, strong) IBOutlet UIView * dateSep3;
@property (nonatomic, strong) IBOutlet UIView * sepSelectRooms;
@property (nonatomic, strong) IBOutlet UIView * topSepSelectRooms;
@property (nonatomic, strong) IBOutlet UIView * greenBorder;
@property (nonatomic, strong) IBOutlet UILabel * roomDropDownLabel;
@property (nonatomic, strong) IBOutlet UILabel * adultDropDownLabel;
@property (nonatomic, strong) IBOutlet UILabel * childreanDropDownLabel;
@end
