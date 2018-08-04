/********* LFMapSelectPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MapKit/MapKit.h>

@interface LFMapPluginModel :NSObject

@property (nonatomic,strong) NSString * cityName;
@property (nonatomic,assign) CGFloat longitude;
@property (nonatomic,assign) CGFloat latitude;

@end

@interface LFMapSelectPlugin : CDVPlugin {
  // Member variables go here.
}

- (void)showSheetViewWithModel:(CDVInvokedUrlCommand*)command;
@end

@implementation LFMapPluginModel

@end



@implementation LFMapSelectPlugin

- (void)_showSheetViewWithModel:(LFMapPluginModel *)model{
    
//    LFTitleModel * titleModel = [LFTitleModel new];
//    LFCustomSheet * sheet = [[LFCustomSheet alloc]initSheetText:@[@"f",@"f"] sheetTitleModel:nil clickBlock:^(NSString *sheetTitle) {
//
//    }];
//    [sheet show];
    
//    LFMapPluginModel * testMolel = [LFMapPluginModel new];
//    testMolel.latitude = 23.1066805;
//    testMolel.longitude = 113.3245904;
//    testMolel.cityName = @"广州塔";
    
    [self navigationButtonDidClick:model];
    
}
- (void)navigationButtonDidClick:(LFMapPluginModel *)model
{
    
    CLLocationCoordinate2D  location = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //苹果自带地图
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"苹果自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil]];
        toLocation.name = model.cityName;
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: @YES}];
        
    }];
    [alertController addAction:alertAction1];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",location.latitude,location.longitude, model.cityName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        [alertController addAction:alertAction2];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction * alertAction3 = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"", @"", location.latitude,location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        [alertController addAction:alertAction3];
    }
    
    //取消
    UIAlertAction * alertAction4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:alertAction4];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}


- (void)showSheetViewWithModel:(CDVInvokedUrlCommand *)command{
    
    if(![self check_arguments:command]){
        return;
    }else{
        NSDictionary * dict = command.arguments.firstObject;
        LFMapPluginModel * model = [LFMapPluginModel new];
        model.cityName = [dict objectForKey:@"cityName"];
        model.longitude = [[dict objectForKey:@"longitude"] floatValue];
        model.latitude = [[dict objectForKey:@"latitude"] floatValue];
        [self _showSheetViewWithModel:model];
    }    
}

- (BOOL)check_arguments:(CDVInvokedUrlCommand *)command{
    
    void (^callBackFunc)(NSString * message) = ^(NSString * message){
        CDVPluginResult *pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    NSDictionary * dict = command.arguments.firstObject;
    if((dict==nil)||dict.count<3){
        if(callBackFunc){
            callBackFunc(@"参数 is not valid");
        }
        return NO;
    }
    return YES;
}

@end


