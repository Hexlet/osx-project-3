//
//  HRPDataLoader.h
//  HabraReader Prototype
//
//  Created by Sergey Starukhin on 18.09.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRPDataLoader : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (void)syncDatabaseWithContext:(NSManagedObjectContext *)managedObjectContext fromURL:(NSURL *)URL withCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
