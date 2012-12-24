//
//  Control.m
//  myplayer
//
//  Created by Сергей Голубев on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Control.h"
#import "infoTrack.h"


@implementation Control;
@synthesize silderVolume;
@synthesize tableView;
@synthesize mLabel;


-(IBAction)play:(id)sender
{   
    [pAVPlayer pause];
    [self playTrack];
    
     /*
     AVAsset * asset = [AVURLAsset URLAssetWithURL:objectURL options:nil];
     
     NSArray *metadata = [asset commonMetadata];
     
     AVMetadataItem* item = [metadata objectAtIndex:3];
     
     NSString *value = [item stringValue];
     NSLog(@"Стиль : %@", value);
     
     NSLog(@"%@", [metadata objectAtIndex:3]);
     
     for ( AVMetadataItem* item in metadata ) {
     NSString *key = [item commonKey];
     NSString *value = [item stringValue];
     NSLog(@"key = %@, value = %@", key, value);
     NSLog(@"key = %@", key);
     
     }    
     */
     
    
}

-(IBAction)setIndexTrack:(id)sender
{
    NSLog (@"main current %d", [pAVPlayer currentTime]);
}


-(void)setVolumeTrack
{
    sliderValue = [silderVolume doubleValue];
    pAVPlayer.volume = sliderValue;
}


-(IBAction)setVolume:(id)sender
{
    [self setVolumeTrack];
}

-(IBAction)checkSound:(id)sender
{
    NSLog(@"check");
    if (checkVolume == YES)
    {
        checkVolume = NO;
        pAVPlayer.volume = 0;
    }
    
    else if (checkVolume == NO)
    {
        checkVolume = YES;
        pAVPlayer.volume = sliderValue;
    }
}


-(void)checkBegin
{
    if(numberTrack < 0 )
    numberTrack = (int)[objectInfoTrack count] - 1;
}

-(void)checkEnd
{
    if(numberTrack + 1 > [objectInfoTrack count])
    numberTrack = 0;
}
-(void)awakeFromNib
{
    [tableView setDoubleAction:@selector(listplay:)];
    [tableView setTarget:self];
    
    [silderVolume setMinValue:0.01];
    [silderVolume setMaxValue:0.99];
    [silderVolume setDoubleValue:0.33];
    checkVolume = YES;
    
}

-(IBAction)stop:(id)sender
{
    [pAVPlayer pause]; 
}

-(IBAction)next:(id)sender
{
    ++numberTrack;
    [self checkEnd];
    [pAVPlayer pause];
    [self playTrack];
    
}

-(IBAction)back:(id)sender
{
    --numberTrack;
    [self checkBegin];
    [pAVPlayer pause];
    [self playTrack];
}


-(IBAction)open:(id)sender
{
    [openPanel runModal];
     objectURL = [openPanel URL];
    [self recordToModerlInfoTrack];
}

-(NSString *)recordInInfoTrack:(int)num;
{
    NSArray *metadata = [asset commonMetadata];
    AVMetadataItem* item = [metadata objectAtIndex:num]; 
    return [item stringValue];

}

-(void)recordToModerlInfoTrack
{
    pInfoTrack = [[infoTrack alloc]init];
    asset = [AVURLAsset URLAssetWithURL:objectURL options:nil];
    pInfoTrack.len = (asset.duration).value;
    pInfoTrack.nameGenre = [self recordInInfoTrack:3];
    pInfoTrack.nameArtist = [self recordInInfoTrack:5];
    pInfoTrack.nameAlbum = [self recordInInfoTrack:0];
    pInfoTrack.nameTrack = [self recordInInfoTrack:2];
    
    pInfoTrack.urlTrack = objectURL;
    
    [objectInfoTrack addObject:pInfoTrack];
    
    [list addObject:pInfoTrack];
    NSLog(@"time main : %lld", pInfoTrack.len);
    [tableView reloadData];
    
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [list count];
}

- (void)listplay:(id)sender
{
    numberTrack = [tableView selectedRow];
    [pAVPlayer pause];
    [self playTrack];
    
}

-(void)selectedTrackList
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:numberTrack];
    [tableView selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    infoTrack * pif = [list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    return [pif valueForKey:identifier];
}



-(NSString *)readinfoTrack
{
    NSString * title = [NSString localizedStringWithFormat:@"%@ - %@\n%@\n%@",
                        [[objectInfoTrack objectAtIndex:numberTrack] nameArtist],
                        [[objectInfoTrack objectAtIndex:numberTrack] nameTrack],
                        [[objectInfoTrack objectAtIndex:numberTrack] nameAlbum],
                        [[objectInfoTrack objectAtIndex:numberTrack] nameGenre]];
    
    return  title;
}

-(void) SomeAction:(id)anObject
{
    
    // тут код функции
    NSLog(@"click");
   // [pAVPlayer pause];
    NSLog(@"time thread : %d", pInfoTrack.len);
    //[indexTimeTrack setMaxValue:(pInfoTrack.len)];
    //[indexTimeTrack setMinValue:0];
    //[indexTimeTrack setIntValue:0];
    
    AVPlayer * ppAVPlayer = [[AVPlayer alloc]init];
    
    ppAVPlayer = pAVPlayer;
    
    NSLog(@"%d",[ppAVPlayer currentItem]);
    
    [NSThread exit];
    
    // защита от утечек памяти
}

-(void)playTrack
{
    [pAVPlayer initWithURL:[[objectInfoTrack objectAtIndex:numberTrack] urlTrack]];
    [pAVPlayer play];
    [self setVolumeTrack];
    
    [[objectInfoTrack objectAtIndex:numberTrack] nameTrack];
    
    [mLabel setStringValue:[self readinfoTrack]];
    [self selectedTrackList];
    [NSThread detachNewThreadSelector:@selector(SomeAction:) toTarget:self withObject:pAVPlayer];
}



-(id)init
{
    NSLog(@"init Control");
    
    // ициализация плеера
    
    pAVPlayer = [[AVPlayer alloc]init];
    list = [[NSMutableArray alloc]init];
    pMA = [[NSMutableArray alloc]init];
    objectInfoTrack = [[NSMutableArray alloc]init];
    openPanel = [NSOpenPanel openPanel];
    numberTrack = 0;
    return self;
}

@end
