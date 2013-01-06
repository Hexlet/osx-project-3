//
//  BookViewController.m
//  CartiAudio
//
//  Created by Dmitry on 18.12.12.
//  Copyright (c) 2012 DmitryDev. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController


@synthesize xmlData,xmlDictionary;
@synthesize autoriCarous;
@synthesize bookItems;
@synthesize sliderPageControl;
@synthesize sliderPageBookControl;

@synthesize totalAutors;
@synthesize allBooksDictionary;
@synthesize currentBookData;
@synthesize currentAuthorID;

@synthesize chapterListArray;
#define  textviewFrameiPad CGRectMake(20.0f, 20.0f, 154.0f, 154.0f)
#define chapterCaruselFrame CGRectMake(20.0f, 120.0f, 661.0f, 91.0f)
#define maxElements 7

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.bookItems=[[NSMutableArray alloc] init];
        self.xmlData=[[NSMutableArray alloc] init];
        self.xmlDictionary=[[NSMutableDictionary alloc] init];
        self.allBooksDictionary = [[NSMutableDictionary alloc] init];
        
        self.chapterListArray=[[NSMutableArray alloc] init];
        
        
        if (!self.totalAutors)
        {
            self.totalAutors=maxElements;
        }
        
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

    
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed: @"SliderPageControl.bundle/images/sliderPageControlLeft.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    [self.soundSlider setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    
    UIImage *sliderRightTrackImage = [[UIImage imageNamed: @"blackSliderRight"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    [self.soundSlider setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    
    UIImage *sliderThumb = [[UIImage imageNamed: @"SliderPageControl.bundle/images/sliderPageControl.png"] stretchableImageWithLeftCapWidth: 10 topCapHeight: 10];
    [self.soundSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    
    int originSlider=25;
    self.sliderPageControl = [[SliderPageControl  alloc] initWithFrame:CGRectMake(originSlider,self.autoriCarous.frame.size.height-originSlider
                                                                                  ,self.autoriCarous.frame.size.width-2*originSlider,20)];
    [self.sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderPageControl setDelegate:self];
    [self.sliderPageControl setShowsHint:YES];
    [self.autoriCarous addSubview:self.sliderPageControl];
    [self.sliderPageControl setNumberOfPages:[self.bookItems count]];
    [self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
        
    self.bookCarousel.type = iCarouselTypeCoverFlow;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.bookItems count]; //[self.autorItems count];
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UITextView *textView ;
    UILabel *label;
    
    int lblHeight=25,indent=4;
    
    self.currentBookData=[self.bookItems objectAtIndex:index];
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)] ;
        ((UIImageView *)view).image = [UIImage imageNamed:@"page"];
        view.contentMode = UIViewContentModeCenter;
        
        
       // label.text=self.currentBookData.name;      

        //[self.view addSubview:textView];

        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(indent, 2*indent, view.bounds.size.width-2*indent, view.bounds.size.height-2*indent)] ;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:18];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 5;
        label.text = [NSString stringWithFormat:
                      @"Book %@\n %@ \n %@ %@ \n %@ %@",
                      self.currentBookData.idb,
                      self.currentBookData.name,
                      self.currentBookData.category,
                      self.currentBookData.lenghtMinutes,
                      self.currentBookData.yearOfPublishing,
                      self.currentBookData.yearOfRecording];
        [view addSubview:label];
        
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        textView = (UITextView *)[view viewWithTag:2];
    }
    
    
    
    ChapterViewController *chapterController = [[ChapterViewController alloc] initWithNibName:@"ChapterViewController" bundle:nil];
    chapterController.allChaptersInt=[[self.currentBookData numberOfFiles] integerValue];
    
     [self.chapterListArray addObject:chapterController];
  //  NSLOg(@"allbooks %@",  );
    
    // autBookController.bookItems=[self.allBooksDictionary objectForKey:authorXML.autorID];
    
    //  autBookController.bookItems=[self.allBooksDictionary objectForKey:key];
    
    //NSLog(@"author ID %@ , books %@",[authorXML autorID],autBookController.bookItems);
    
   
 
     
    //adding first view
    if (index == 0)
    {
        chapterController.view.frame=chapterCaruselFrame;
        chapterController.view.layer.borderWidth=1.;
        //autBookController.view.layer.borderColor = [UIColor whiteColor].CGColor;;
        chapterController.view.layer.cornerRadius=10;
        chapterController.view.clipsToBounds=YES;
        [self.view addSubview:chapterController.view];
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
 //   [[[self.chapterListArray objectAtIndex:self.previousIndexView] view] removeFromSuperview];
    NSLog(@"array %@",self.chapterListArray);
    
    BookViewController *autBookController = [self.chapterListArray objectAtIndex:carousel.currentItemIndex];
    autBookController.view.frame=chapterCaruselFrame;
    autBookController.view.layer.borderWidth=1;
    autBookController.view.layer.cornerRadius=10;
    autBookController.view.clipsToBounds=YES;
    [self.view addSubview:autBookController.view];

}

-(void) carouselDidEndDecelerating:(iCarousel *)carousel
{
   // NSLog(@"index, %d",carousel.currentItemIndex);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.25f;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark sliderPageControlDelegate

//- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
//{
//	//NSString *hintTitle = [[self.demoContent objectAtIndex:page] objectForKey:@"title"];
//	NSString *hintTitle=@"Autor";
//    return hintTitle;
//}

- (void)onPageChanged:(id)sender
{
	
    
	[self slideToCurrentPage:YES];
}

- (void)slideToCurrentPage:(bool)animated
{
	int page = self.sliderPageControl.currentPage;
	
    CGRect frame = self.autoriCarous.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.autoriCarous scrollToItemAtIndex:page animated:YES ];
}

- (void)changeToPage:(int)page animated:(BOOL)animated
{
	[self.sliderPageControl setCurrentPage:page animated:YES];
	[self slideToCurrentPage:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAutoriCarous:nil];
    [self setBookCarousel:nil];
    [self setSoundSlider:nil];
    [self setCoverView:nil];
    [super viewDidUnload];
}
@end
