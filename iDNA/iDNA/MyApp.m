//
//  MyApp.m
//  iDNA
//
//  Created by Александр Борунов on 19.12.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//

#import "MyApp.h"
#import "Document.h"

@implementation MyApp
-(void)sendEvent:(NSEvent *)theEvent{
    if ([theEvent type] == NSApplicationDefined) {  // интересуют только события определенные нашим приложением
        for (Document * doc in [[NSDocumentController sharedDocumentController] documents]){ // получили список документов
            if (doc.docID == theEvent.data1){
                [doc doing];
            }
        }
    }
    else {
        [super sendEvent:theEvent];
    }
}

@end
