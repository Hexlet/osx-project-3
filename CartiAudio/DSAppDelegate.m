//
//  DSAppDelegate.m
//  Carti Audio
//
//  Created by Dmitry on 07.12.12.
//  Copyright (c) 2012 Dmitry. All rights reserved.
//

#import "DSAppDelegate.h"

#import "DSViewController.h"
#import "XMLParserViewController.h"
#import "XMLReader.h"
@implementation DSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSDate* date = [ [ NSDate alloc ] init ];
    
    void (^printDate)() = ^() {
        NSLog( @"date: %@", date );
    };
    
    //копируем блок в кучу
    printDate = [[printDate copy ] autorelease ];
    
    [date release ];
    
    printDate();
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //begin parsing data from server
    XMLParserViewController *parser=[[XMLParserViewController alloc]init];
    [parser startParsingAuthors];
    //NSLog(@"dict parsed %@",parser.xmlAuthorsData);
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[DSViewController alloc] initWithNibName:@"DSViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[DSViewController alloc] initWithNibName:@"DSViewController_iPad" bundle:nil];
    }
 
    self.viewController.autorItems=parser.xmlAuthorsData;
    self.viewController.totalAutorsCount=[parser.xmlAuthorsData count];
    
    for (int i=0;i < [parser.xmlAuthorsData count]; i++)
    {
        
        if ([[parser.xmlAuthorsData objectAtIndex:i] autorID])
        {
            [parser startParsingBooksWithAuthorId:[[parser.xmlAuthorsData objectAtIndex:i] autorID]];
            [self.viewController.allBooksDictionary setObject:parser.xmlBooksData forKey:[[parser.xmlAuthorsData objectAtIndex:i] autorID]];
           // [self.viewController.xmlDictionary setObject:[parser.xmlAuthorsData objectAtIndex:i] forKey:[[parser.xmlAuthorsData objectAtIndex:i] autorID]];
           // NSLog(@"%@ id parsing  data %@",[[parser.xmlAuthorsData objectAtIndex:i] autorID], parser.xmlBooksData);
        }
        else
        {
            //
        }
    }

    //self.viewController.xmlData=parser.xmlOutputData;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
