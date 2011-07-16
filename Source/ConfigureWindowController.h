/* ConfigureWindowController */

#import <AppKit/AppKit.h>
#import <ScreenSaver/ScreenSaver.h>

@interface ConfigureWindowController : NSWindowController
{
	IBOutlet NSTextField *activationScriptLocation;
	IBOutlet NSTextField *deactivationScriptLocation;
	IBOutlet NSPopUpButton *saverList;
    IBOutlet NSButton *actAsynch;
    IBOutlet NSButton *deactAsynch;
    IBOutlet NSButton *showDesktop;
    
    ScreenSaverDefaults *defaults;
}

- (IBAction)chooseActivationLocation:(id)sender;
- (IBAction)chooseDeactivationLocation:(id)sender;
- (IBAction)okAction:(id)sender;

- (NSString *)activationScriptLocationString;
- (NSString *)deactivationScriptLocationString;
- (NSString *)saverLocation;
- (BOOL)activateAsynch;
- (BOOL)deactivateAsynch;
- (BOOL)showDesktop;

@end
