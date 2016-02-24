//
//  AppDelegate.h
//  Emergency
//
//  Created by star on 2/24/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, assign) float                 currentLat;
@property (nonatomic, assign) float                 currentLng;

+(AppDelegate*) getDelegate;
@end

