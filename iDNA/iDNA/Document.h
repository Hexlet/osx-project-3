//
//  Document.h
//  iDNA
//
//  Created by Anatoly Yashkin on 21.12.12.
//  Copyright (c) 2012 Anatoly Yashkin. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Document : NSDocument{
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    NSInteger bestMatch;

}


@property (weak) IBOutlet NSTextFieldCell *goalDNATF;
@property (weak) IBOutlet NSTextField *bestMatchLabel;

- (IBAction)startEvalution:(id)sender;

@end
