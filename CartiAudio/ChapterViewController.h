//
//  ChapterViewController.h
//  CartiAudio
//
//  Created by Dmitry on 21.12.12.
//  Copyright (c) 2012 DmitryDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface ChapterViewController : UIViewController <iCarouselDataSource,iCarouselDelegate>

@property (strong, nonatomic) NSMutableArray *chapterItemsArr;
@property (strong, nonatomic) NSMutableDictionary *allBooksDictionary;
@property (strong, nonatomic) IBOutlet iCarousel *chapterCarousel;
@property (assign, nonatomic) NSInteger *currentChapter;

@property (assign, nonatomic) NSInteger allChaptersInt;

@end
