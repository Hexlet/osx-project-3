//
//  DSViewController.h
//  Carti Audio
//
//  Created by Dmitry on 07.12.12.
//  Copyright (c) 2012 Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "SliderPageControl.h"
#import "AuthorDataModel.h"
#import "BookItemDataModel.h"
#import "BookViewController.h"
@interface DSViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,SliderPageControlDelegate>

@property (nonatomic) int totalAutorsCount;
@property (strong, nonatomic)  NSMutableArray *xmlData;
@property (strong, nonatomic)  NSMutableDictionary *xmlDictionary;

@property (strong, nonatomic) IBOutlet iCarousel *autoriCarous;
@property (strong, nonatomic) IBOutlet iCarousel *bookCarousel;
@property (strong, nonatomic) NSMutableArray *autorItems;
@property (nonatomic, assign) BOOL pageControlUsed;

@property (strong, nonatomic) IBOutlet UISlider *soundSlider;
@property (nonatomic, strong) SliderPageControl *sliderPageControl;
@property (assign, nonatomic) NSInteger previousIndexView;


@property (strong, nonatomic) IBOutlet UIView *coverView;

//books
@property (strong, nonatomic) NSMutableDictionary *allBooksDictionary;
@property (strong, nonatomic) NSString *currentAuthorID;
@property (strong, nonatomic) NSMutableArray *booksControllerArray;



@end
