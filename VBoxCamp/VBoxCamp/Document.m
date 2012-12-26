//
//  Document.m
//  VBoxCamp
//
//  Created by Dmitriy Zavorokhin on 12/26/12.
//  Copyright (c) 2012 goodman116@gmail.com. All rights reserved.
//

#import "Document.h"
#import "Volume.h"

#include <sys/stat.h>

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        volumes = [self volumesInfo];
    }
    return self;
}

- (NSArray *)volumesInfo {
    
    // Get a list of mounted non-hidden volumes
    NSArray *volumeURLs = [[NSFileManager defaultManager] mountedVolumeURLsIncludingResourceValuesForKeys:nil options:NSVolumeEnumerationSkipHiddenVolumes];
    NSUInteger size = [volumeURLs count];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:size];
    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    
    for (NSURL *url in volumeURLs) {
        NSString *label = [url lastPathComponent];
        // Escape root mount point 
        if (![label isEqualToString:@"/"]) {
            Volume *v = [[Volume alloc] init];
        
            // Create DADisk for the volume
            DADiskRef volumeDisk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, (__bridge CFURLRef)url);
        
            // Filter out files/directories that aren't volumes
            if (volumeDisk) {
                // Get disk description
                NSDictionary *description = (__bridge_transfer NSDictionary *)DADiskCopyDescription(volumeDisk);
            
                [v setLabel:label];
                // Add mount point
                [v setMountPoint:[url path]];
                // Add BSD disk identifier in format discXsX
                [v setBsdId:[description objectForKey: (__bridge id)kDADiskDescriptionMediaBSDNameKey]];
                [result addObject:v];
                CFRelease(volumeDisk);
            }
        }
    }
    CFRelease(session);
    return result;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    int bcIndex = -1;
    int i = 0;
    for (Volume *v in volumes) {
        if ([v.label isEqualToString:@"BOOTCAMP"]) {
            bcIndex = i;
        }
        i++;
    }
    if (bcIndex != -1) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:bcIndex];
        [_volumesTableView selectRowIndexes:indexSet byExtendingSelection:NO];
    }
    if (volumes != nil) {
        [self appendTextToDetails:@"Getting volumes information... Done."];
        [self appendTextToDetails:@""];
    }
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

- (IBAction)createBootcampVM:(id)sender {
    Volume *v = [volumes objectAtIndex:[_volumesTableView selectedRow]];
    
//    NSTask *task = [[NSTask alloc] init];
//    [task setLaunchPath: @"chmod"];
//    
//    NSString *hd = [NSString stringWithFormat:@"/dev/%@", v.bsdId];
//    NSArray *arguments = [NSArray arrayWithObjects: @"777", hd, nil];
//    [task setArguments: arguments];
//    
//    NSPipe *pipe = [NSPipe pipe];
//    [task setStandardOutput: pipe];
//    
//    NSFileHandle *file = [pipe fileHandleForReading];
//    
//    [task launch];
//    
//    NSData *data = [file readDataToEndOfFile];
//    
//    NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//    NSLog (@"chmod returned:\n%@", string);
    
    
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSError *error = nil;
//    NSDictionary *attribs = [fm attributesOfItemAtPath:hd error:&error];
//    int permissions = [[attribs objectForKey:@"NSFilePosixPermissions"] intValue];
//    permissions |= (S_IRWXU | S_IRWXG | S_IRWXO);
//    NSDictionary *newattribs = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:permissions]
//                                               forKey:NSFilePosixPermissions];
//    [fm setAttributes:newattribs ofItemAtPath:hd error:&error];
    
    NSString *chmod_dev = [NSString stringWithFormat:@"sudo chmod a+rw /dev/%@ ...", v.bsdId];
    NSMutableString *source = [[NSMutableString alloc] init];
    [source appendString:@"do shell script \""];
    [source appendString:chmod_dev];
    [source appendString:@"\" with administrator privileges"];
    [self appendTextToDetails:[NSString stringWithFormat:@"Running script: %@", chmod_dev]];
//    [self appendTextToDetails:chmod_dev];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    NSDictionary *errorDict;
    [script executeAndReturnError:&errorDict];
    [self appendTextToDetails:@"Done."];
}


-(void)appendTextToDetails:(NSString *)aString {
    NSMutableString *ms = [NSMutableString stringWithString:[_detailsTextView string]];
    [ms appendString:aString];
    [ms appendString:@"\n"];
    [_detailsTextView setString:ms];
}

@end
