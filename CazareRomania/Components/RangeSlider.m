//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Mal Curtis on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RangeSlider.h"

@interface RangeSlider (PrivateMethods)
-(float)xForValue:(float)value;
-(float)valueForX:(float)x;
-(void)updateTrackHighlight;
@end

@implementation RangeSlider

@synthesize minimumValue, maximumValue, minimumRange, selectedMinimumValue, selectedMaximumValue, _trackBackground,_pretulMinim,_pretulMaxim;;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect newFrame=CGRectMake(15,
                                   frame.origin.y, 
                                   frame.size.width-30, 
                                   10);
        
        _minThumbOn = false;
        _maxThumbOn = false;
        _padding = 20;
        
        _trackBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-background.png"]] ;
        _trackBackground.frame=newFrame;
        _trackBackground.center = self.center;
        [self addSubview:_trackBackground];
        
        _track = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-highlight.png"]];
        _track.frame=newFrame;
        _track.center = self.center;
        [self addSubview:_track];
        
        _minThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]];
        _minThumb.frame = CGRectMake(0,0, self.frame.size.height,self.frame.size.height);
        _minThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_minThumb];
        
        _maxThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]];
        _maxThumb.frame = CGRectMake(0,0, self.frame.size.height,self.frame.size.height);
        _maxThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_maxThumb];
        _pretulMinim = [[UILabel alloc] init];
        _pretulMinim.frame = CGRectMake(0,0,40,0);
        _pretulMinim.contentMode = UIViewContentModeCenter;
        _pretulMaxim = [[UILabel alloc] init];
        _pretulMaxim.frame = CGRectMake(0,0,40,0);
        _pretulMaxim.contentMode = UIViewContentModeCenter;
        _pretulMinim.hidden=YES;
        _pretulMaxim.hidden =YES;
        [self addSubview:_pretulMinim];
        [self addSubview:_pretulMaxim];
        
    }
    
    return self;
}


-(void)layoutSubviews
{
    // Set the initial state
    _minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], self.center.y);
    _maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], self.center.y);
    //JMODE
    
    _pretulMinim.center = CGPointMake(_minThumb.center.x, self.center.y -15);
    _pretulMaxim.center = CGPointMake(_maxThumb.center.x, self.center.y +30);
    
//    NSLog(@"Tapable size %f", _minThumb.bounds.size.width); 
    [self updateTrackHighlight];
    
    
}

-(void)refreshSliders{
    _minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], self.center.y);
    _maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], self.center.y);
    _pretulMinim.center = CGPointMake(_minThumb.center.x, self.center.y -15);
    _pretulMaxim.center = CGPointMake(_maxThumb.center.x, self.center.y +30);
    
//    NSLog(@"Tapable size %f", _minThumb.bounds.size.width); 
    [self updateTrackHighlight];
}

-(float)xForValue:(float)value{
    return (self.frame.size.width-(_padding*2))*((value - minimumValue) / (maximumValue - minimumValue))+_padding;
}

-(float) valueForX:(float)x{
    return minimumValue + (x-_padding) / (self.frame.size.width-(_padding*2)) * (maximumValue - minimumValue);
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_minThumbOn && !_maxThumbOn){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if(_minThumbOn){
        _minThumb.center = CGPointMake(MAX([self xForValue:minimumValue],MIN(touchPoint.x - distanceFromCenter, [self xForValue:selectedMaximumValue - minimumRange])), _minThumb.center.y);
        selectedMinimumValue = [self valueForX:_minThumb.center.x];
         _pretulMinim.center = CGPointMake(_minThumb.center.x, self.center.y -15);
//          NSLog(@"a very strange day 1 %f", _pretulMinim.center.x);
    }
    if(_maxThumbOn){
        _maxThumb.center = CGPointMake(MIN([self xForValue:maximumValue], MAX(touchPoint.x - distanceFromCenter, [self xForValue:selectedMinimumValue + minimumRange])), _maxThumb.center.y);
        selectedMaximumValue = [self valueForX:_maxThumb.center.x];
      
      
        _pretulMaxim.center = CGPointMake(_maxThumb.center.x, self.center.y +30);

//        NSLog(@"a very strange day  2 %f", _pretulMaxim.center.x);
    }
    [self updateTrackHighlight];
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
    if(CGRectContainsPoint(_minThumb.frame, touchPoint)){
        _minThumbOn = true;
        distanceFromCenter = touchPoint.x - _minThumb.center.x;
    }
    else if(CGRectContainsPoint(_maxThumb.frame, touchPoint)){
        _maxThumbOn = true;
        distanceFromCenter = touchPoint.x - _maxThumb.center.x;
        
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _minThumbOn = false;
    _maxThumbOn = false;
}

-(void)updateTrackHighlight{
	_track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
