//
//  Document.h
//  iDNA
//
//  Created by vladimir on 14.01.13.
//  Copyright (c) 2013 Владимир Ковалев. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell+mutate.h"

@interface Document : NSDocument {
    Cell * DNA;
    NSInteger length;
    NSMutableArray * Population;
    NSInteger population_size;
}
@property (weak) IBOutlet NSTextField *goalDnaLabel;

-(void) createPopulation:(NSInteger) x;

- (IBAction)startEvolution:(id)sender;

@property (weak) IBOutlet NSTextField *populationSize;
@property (weak) IBOutlet NSTextField *generation;
@property (weak) IBOutlet NSTextField *hammingDistance;

@end
