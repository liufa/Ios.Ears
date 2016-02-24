//
//  ViewController.m
//  Emergency
//
//  Created by star on 2/24/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController ()
{
    IBOutlet UILabel            *lbStart;
    
    int                         currentStatus;
    NSString                    *guid;
    NSString                    *route;
    
    NSTimer                     *timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    currentStatus = STATUS_NONE;
    [self registerAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) registerAccount
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    hud.labelText = @"Registering Account...";
    
    [[NetworkClient sharedClient] registerAccount: [[UIDevice currentDevice].identifierForVendor UUIDString]
                                              lat: [AppDelegate getDelegate].currentLat
                                              lng: [AppDelegate getDelegate].currentLat
                                          success:^(id responseObject) {

                                              [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
                                              
                                              currentStatus = STATUS_REGISTER;
                                              guid = [responseObject stringByReplacingOccurrencesOfString: @"\"" withString: @""];
                                              NSLog(@"register successed. guid = %@", responseObject);

                                          } failure:^(NSError *error) {
                                              
                                              NSLog(@"register error = %@", error);
                                              [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
                                              [self showErrorMessage: MSG_ERROR_INTERNET];
                                          }];
}

- (void) startCall
{
    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    [[NetworkClient sharedClient] startCall: guid
                                        lat: [AppDelegate getDelegate].currentLat
                                        lng: [AppDelegate getDelegate].currentLng
                                    success:^(id responseObject) {
                                       
                                        [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
                                        lbStart.text = @"Stop";
                                        currentStatus = STATUS_CALLING;
                                        
                                        NSLog(@"route response = %@", responseObject);
                                        route = responseObject;
                                        if(timer)
                                        {
                                            [timer invalidate];
                                            timer = nil;
                                        }
                                        
                                        timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_DURATION target: self selector: @selector(updateGPS) userInfo: nil repeats: YES];
                                        
                                    } failure:^(NSError *error) {
                                        NSLog(@"start call error = %@", error);
                                        [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
                                        [self showErrorMessage: MSG_ERROR_INTERNET];
                                    }];
}

- (void) updateGPS
{
    [[NetworkClient sharedClient] updateGPS: guid
                                      route: route
                                        lat: [AppDelegate getDelegate].currentLat
                                        lng: [AppDelegate getDelegate].currentLng
                                    success:^(id responseObject) {
                                        
                                        NSLog(@"update gps response = %@", responseObject);
                                        
                                    } failure:^(NSError *error) {
                                        
                                        NSLog(@"update gps call error = %@", error);
                                        
                                    }];
}

- (void) stopCall
{
    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    [[NetworkClient sharedClient] stopCall: guid route: route
                                    success:^(id responseObject) {
                                        
                                        [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
                                        lbStart.text = @"Start";
                                        currentStatus = STATUS_REGISTER;
                                        
                                        NSLog(@"finish response = %@", responseObject);
                                        if(timer)
                                        {
                                            [timer invalidate];
                                            timer = nil;
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        NSLog(@"finish call error = %@", error);
                                        [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
                                        [self showErrorMessage: MSG_ERROR_INTERNET];
                                    }];
}

- (IBAction) actionStart:(id)sender
{
    if(currentStatus == STATUS_REGISTER)
    {
        [self startCall];
    }
    else if(currentStatus == STATUS_CALLING)
    {
        [self stopCall];
    }
    else
    {
        [self registerAccount];
    }
}

- (void) showErrorMessage: (NSString*) message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Error"
                                                                   message: message
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction: actionOk];
    [self presentViewController: alert animated: YES completion: nil];
}
@end
