//
//  DSViewController.m
//  Carti Audio
//
//  Created by Dmitry on 07.12.12.
//  Copyright (c) 2012 Dmitry. All rights reserved.
//

#import "DSViewController.h"
#import "SliderPageControl.h"
#define bookCaruselFrame CGRectMake(20, 486, 728, 180);


@interface DSViewController ()

@end

@implementation DSViewController
@synthesize xmlData,xmlDictionary;
@synthesize autoriCarous;
@synthesize autorItems;
@synthesize sliderPageControl;

@synthesize pageControlUsed;
@synthesize totalAutorsCount;
@synthesize allBooksDictionary;

@synthesize currentAuthorID;
@synthesize booksControllerArray;
@synthesize previousIndexView;

#define maxElements 7

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.autorItems=[[NSMutableArray alloc] init];
        self.xmlData=[[NSMutableArray alloc] init];
        self.xmlDictionary=[[NSMutableDictionary alloc] init];
        self.allBooksDictionary = [[NSMutableDictionary alloc] init];
        self.booksControllerArray=[[NSMutableArray alloc] init];
        
        if (!self.totalAutorsCount)
        {
            self.totalAutorsCount=maxElements;
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
    [self.sliderPageControl setNumberOfPages:[self.autorItems count]];
    [self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
  
    
    
    self.autoriCarous.type=iCarouselTypeCoverFlow;
    self.autorItems=[[NSMutableArray alloc] init];
    self.autoriCarous.dataSource=self;
    self.autoriCarous.delegate=self;
    self.autoriCarous.layer.borderWidth=1;
    self.autoriCarous.layer.cornerRadius=10;
    self.autoriCarous.type = iCarouselTypeCoverFlow;
    
        
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.autorItems count]; //[self.autorItems count];
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label,*datesLbl = nil;
    int lblHeight=25,indent=4,imgHeight=120;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)] ;
        ((UIImageView *)view).image = [UIImage imageNamed:@"page"];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(indent, indent, view.bounds.size.width-2*indent, lblHeight)] ;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:18];    
        [view addSubview:label];
      
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    
    if (index<[self.autorItems count])
    {
        
//        NSString *target = [NSString stringWithFormat:@"%d",index];
//        for (int i = 0; i<self.totalAutors; i++) {
//            NSString *key = [NSString stringWithFormat:@"%d",i];
//            AuthorDataModel *authorXML=[self.autorItems objectAtIndex:index] ;
//            
//        }
//        NSSet *keys = [self.autorItems keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
//            return (*stop = [target isEqual:obj]);
//        }];
        
     //   NSString *key = [NSString stringWithFormat:@"%d",index+1];
        AuthorDataModel *authorXML=[self.autorItems objectAtIndex:index] ;
        
        if (authorXML)
            {
            NSURL* aURL = [NSURL URLWithString:authorXML.smallLogoLink];              
            NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
                
           //     NSLog(@"img link %@",aURL);
            UIImageView *imgView= [[UIImageView alloc] initWithFrame:CGRectMake(indent, lblHeight+indent, view.bounds.size.width-2*indent, imgHeight)];
            imgView.image=[UIImage imageWithData:data];
            [view addSubview:imgView];
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                    
            NSString *autorFullName=[NSString stringWithFormat:@"%@ %@",authorXML.authorName,authorXML.authorSurname];
            label.text= autorFullName;
             
            NSString *datesStr=[NSString stringWithFormat:@"%@ - %@",authorXML.birthDate,authorXML.endDate];
            
            datesLbl = [[UILabel alloc] initWithFrame:CGRectMake(indent, indent+imgHeight +lblHeight, view.bounds.size.width-2*indent, lblHeight)] ;
            datesLbl.backgroundColor = [UIColor clearColor];
            datesLbl.textAlignment = UITextAlignmentCenter;
            datesLbl.font = [label.font fontWithSize:14];
            datesLbl.text = datesStr;
            [view addSubview:datesLbl];
            
        }
        
        BookViewController *autBookController = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
        autBookController.bookItems=[self.allBooksDictionary objectForKey:authorXML.autorID];
       
      //  autBookController.bookItems=[self.allBooksDictionary objectForKey:key];
        
        //NSLog(@"author ID %@ , books %@",[authorXML autorID],autBookController.bookItems);
        
        [self.booksControllerArray addObject:autBookController];
     
        //adding first view
        if (index == 0)
        {
            autBookController.view.frame=bookCaruselFrame;
            autBookController.view.layer.borderWidth=1.;
            //autBookController.view.layer.borderColor = [UIColor whiteColor].CGColor;;
            autBookController.view.layer.cornerRadius=10;
            autBookController.view.clipsToBounds=YES;
            [self.view addSubview:autBookController.view];
        }
        //[self.view addSubview:[[self.booksControllerArray objectAtIndex:carousel.currentItemIndex] view]];
    }
    
    
    //label.text = [[autorItems objectAtIndex:index] stringValue]; [NSString stringWithFormat:@"%@ %@",[self.xmlDictionary objectForKey:@"authorName"],[self.xmlDictionary objectForKey:@"authorSurname"]];
    
    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    self.sliderPageControl.currentPage= index;
}

//adding books
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    self.previousIndexView=carousel.currentItemIndex;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    //NSLog(@"deleted %d", self.previousIndexView);
    [[[self.booksControllerArray objectAtIndex:self.previousIndexView] view] removeFromSuperview];
  
    BookViewController *autBookController = [self.booksControllerArray objectAtIndex:carousel.currentItemIndex];
    autBookController.view.frame=bookCaruselFrame;
    autBookController.view.layer.borderWidth=1;
    autBookController.view.layer.cornerRadius=10;
     autBookController.view.clipsToBounds=YES;
    [self.view addSubview:autBookController.view];
    
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
                return value * 1.35f;            
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
	self.pageControlUsed = YES;
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
