//
//  PitbulCommandProvider.m
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 12/2/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import "PitbulActionProvider.h"
#import "Constants.h"
#import "SettingsUtils.h"
#import "PitbulAction.h"

@implementation PitbulActionProvider

- (id)init {
    if (self = [super init]) {
//        NSString *pitbulPhoneNumber = [SettingsUtils pitbulPhoneNumber];
        
        _managementActions = [NSArray arrayWithObjects:
//                              [PitbulAction initWithAction:pitbulPhoneNumber andTitle:pitbulPhoneNumber andType:CALL],
                              [PitbulAction initWithAction:MA_AM andTitle:NSLocalizedString(MA_AM, nil)],
                              [PitbulAction initWithAction:MA_DM andTitle:NSLocalizedString(MA_DM, nil)],
                              nil];
        
        _serviceActions = [NSArray arrayWithObjects:
                           [PitbulAction initWithAction:SA_GM andTitle:NSLocalizedString(SA_GM, nil)],
                           [PitbulAction initWithAction:SA_ST andTitle:NSLocalizedString(SA_ST, nil)],
                           [PitbulAction initWithAction:SA_PW andTitle:NSLocalizedString(SA_PW, nil)],
                           [PitbulAction initWithAction:SA_ID andTitle:NSLocalizedString(SA_ID, nil)],
                           [PitbulAction initWithAction:SA_IM andTitle:NSLocalizedString(SA_IM, nil)],
                           [PitbulAction initWithAction:SA_GL andTitle:NSLocalizedString(SA_GL, nil)],
                           [PitbulAction initWithAction:SA_S1 andTitle:NSLocalizedString(SA_S1, nil)],
                           [PitbulAction initWithAction:SA_S0 andTitle:NSLocalizedString(SA_S0, nil)],
                           [PitbulAction initWithAction:SA_SM andTitle:NSLocalizedString(SA_SM, nil)],
                           nil];
        
        _totalActions = [_managementActions arrayByAddingObjectsFromArray:_serviceActions];
    }
    return self;
}

- (PitbulAction *)actionByTitle:(NSString *)title {
    for(PitbulAction *pa in _totalActions) {
        if ([title isEqualToString:pa.title]) {
            return pa;
        }
    }
    return nil;
}

@end
