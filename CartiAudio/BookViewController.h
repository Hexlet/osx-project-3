//
//  BookViewController.h
//  CartiAudio
//
//  Created by Dmitry on 18.12.12.
//  Copyright (c) 2012 DmitryDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "SliderPageControl.h"

#import "BookItemDataModel.h"
#import "ChapterViewController.h"

@interface BookViewController : UIViewController <iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet iCarousel *bookCarousel;
@property (strong, nonatomic) NSMutableArray *bookItems;


@property (nonatomic) int totalAutors;
@property (strong, nonatomic)  NSMutableArray *xmlData;
@property (strong, nonatomic)  NSMutableDictionary *xmlDictionary;

@property (strong, nonatomic) IBOutlet iCarousel *autoriCarous;


@property (strong, nonatomic) IBOutlet UISlider *soundSlider;
@property (nonatomic, strong) SliderPageControl *sliderPageControl;
@property (nonatomic, strong) SliderPageControl *sliderPageBookControl;
@property (strong, nonatomic) IBOutlet UIView *coverView;

//books
@property (strong, nonatomic) NSMutableDictionary *allBooksDictionary;
@property (strong, nonatomic) BookItemDataModel *currentBookData;
@property (strong, nonatomic) NSString *currentAuthorID;


@property (strong, nonatomic) NSMutableArray *chapterListArray;

@end
