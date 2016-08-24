

#import <UIKit/UIKit.h>

@class ViewControllerDaysiDevicePair;

@protocol ViewControllerDevicePairDelegate <NSObject>

-(void) OnUpdateDevicePairId:(ViewControllerDaysiDevicePair *)controller PairingId:(NSString *)strId;
-(void) OnEditingPairId:(ViewControllerDaysiDevicePair *)controller;

@end

@interface ViewControllerDaysiDevicePair : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *UITextFieldDaysiDeviceAddress;
@property (weak, nonatomic) IBOutlet UILabel *UILabelEnterID;

@property (weak, nonatomic) IBOutlet UIButton *UIButtonQRCode;

@property (nonatomic, weak) id <ViewControllerDevicePairDelegate> delegate;
@property (weak, nonatomic) NSString * strDeviceId;

@end
