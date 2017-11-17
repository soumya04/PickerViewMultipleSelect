//
//  AppDelegate.h
//  MultiplePickerView
//
//  Created by Jeevan on 27/09/17.
//  Copyright © 2017 com.axio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

