//
//  ChapterViewController.m
//  CartiAudio
//
//  Created by Dmitry on 21.12.12.
//  Copyright (c) 2012 DmitryDev. All rights reserved.
//

#import "ChapterViewController.h"

@interface ChapterViewController ()

@end

@implementation ChapterViewController
@synthesize chapterCarousel;
@synthesize currentChapter;
@synthesize  allBooksDictionary;
@synthesize chapterItemsArr;
@synthesize allChaptersInt;



#define  textviewFrameiPad CGRectMake(20.0f, 20.0f, 154.0f, 154.0f)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.chapterItemsArr=[[NSMutableArray alloc] init];
        self.chapterItemsArr=[[NSMutableArray alloc] init];
        self.allBooksDictionary = [[NSMutableDictionary alloc] init];
  
        
    }
    return self;
}

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.borderWidth=1;
    self.view.layer.cornerRadius=10;
    
    self.chapterCarousel.type = iCarouselTypeLinear;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
   // return [self.chapterItemsArr count]; //[self.autorItems count];
    return self.allChaptersInt;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    UILabel *label;
    
    int lblHeight=25,indent=4;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 100.0f)] ;
        ((UIImageView *)view).image = [UIImage imageNamed:@"page"];
        view.contentMode = UIViewContentModeCenter;
        
        
        // label.text=self.currentBookData.name;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(indent, 2*indent, view.bounds.size.width-2*indent, view.bounds.size.height-2*indent)] ;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:18];
//        label.text = [NSString stringWithFormat:
//                      @"%@ \n %@ %@ \n %@ %@",
//                      self.currentBookData.name,
//                      self.currentBookData.category,
//                      self.currentBookData.lenghtMinutes,
//                      self.currentBookData.yearOfPublishing,
//                      self.currentBookData.yearOfRecording];
        label.text=[NSString stringWithFormat: @"%d",index];
        [view addSubview:label];
        
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
       
    }
    
    
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    
    
    //    if (carousel == self.bookCarousel)
    //    {
    //        //add a bit of spacing between the item views
    //        // label.text =[NSString stringWithFormat:@"Chapter %@",[[autorItems objectAtIndex:index] stringValue]] ;
    //        // label.font = [label.font fontWithSize:20];
    //
    //
    //                    //     AuthorDataModel *authorXML=[self.autorItems objectAtIndex:self.autoriCarous.currentItemIndex] ;
    //            // AuthorDataModel *authorXML=[self.autorItems objectAtIndex:self.autoriCarous.currentItemIndex] ;
    //            self.currentBookData=  [[self.allBooksDictionary objectForKey:@"2"] objectAtIndex:index];
    //
    //            NSLog(@"book %@",self.currentBookData.name);
    //            //   NSLog(@"author %@",[authorXML autorID]);
    //            label.text=[self.currentBookData name];
    //    }
    //label.text = [[autorItems objectAtIndex:index] stringValue]; [NSString stringWithFormat:@"%@ %@",[self.xmlDictionary objectForKey:@"authorName"],[self.xmlDictionary objectForKey:@"authorSurname"]];
    
    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{

}


-(void) carouselDidEndDecelerating:(iCarousel *)carousel
{
    NSLog(@"index, %d",carousel.currentItemIndex);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.55f;
        }
        default:
        {
            return value;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
