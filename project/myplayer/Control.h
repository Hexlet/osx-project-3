//
//  Control.h
//  myplayer
//
//  Created by Дмитрий Голубев on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVMetadataFormat.h>
#import "infoTrack.h"
#import <CoreMedia/CMTime.h>

@interface Control : NSObject <NSTableViewDataSource>{
    
    NSTextField *mLabel;
    AVPlayer * pAVPlayer;
    NSArray  * pItemTracks;
    NSOpenPanel * openPanel;
    NSURL * objectURL;
    NSMutableArray * pMA;
    int numberTrack;
    infoTrack * pInfoTrack;
    AVAsset * asset;
    NSArray *metadata;
    NSMutableArray * objectInfoTrack;
    NSTableView *tableView;
    double sliderValue;
    NSSlider *silderVolume;
    NSMutableArray * list;
    BOOL checkVolume;
    NSSlider *indexTimeTrack;
    
}
-(id)init;
-(IBAction)play:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)stop:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)open:(id)sender;
-(void)recordToModerlInfoTrack;
-(NSString *)recordInInfoTrack:(int)num;
-(NSString *)readinfoTrack;
-(void)playTrack;
-(void)updateMLabel;
-(void)selectedTrackList;
-(void)checkBegin;
-(void)checkEnd;
-(void)awakeFromNib;
-(IBAction)setVolume:(id)sender;
-(IBAction)checkSound:(id)sender;
-(IBAction)setIndexTrack:(id)sender;



@property (strong) IBOutlet NSTextField *mLabel;
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSSlider *silderVolume;
@property (strong) IBOutlet NSSlider *indexTimeTrack;
@end
