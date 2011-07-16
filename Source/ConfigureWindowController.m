#import "ConfigureWindowController.h"

@implementation ConfigureWindowController

- (id)init {
	self = [super initWithWindowNibName:@"ConfigureWindow"];
	
	if (self) {
        // Get the screensaver defaults
		defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"com.swannman.ScriptSaver"];
	}
	return self;
}

- (void)windowDidLoad
{
	int i;
    NSFileManager *manager = [NSFileManager defaultManager];
	
    // Get the screensaver directory paths
	NSString *systemSaverDirectory = @"/System/Library/Screen Savers/";
    NSString *globalSaverDirectory = @"/Library/Screen Savers/";
	NSString *homeDir = NSHomeDirectory();
	NSString *localSaverDirectory = [homeDir stringByAppendingPathComponent:@"/Library/Screen Savers/"];
    
    // Get the system screensavers and append the local screensavers onto the list
	NSMutableArray *saverNames = (NSMutableArray *)[manager directoryContentsAtPath:systemSaverDirectory];
    [saverNames addObjectsFromArray:[manager directoryContentsAtPath:globalSaverDirectory]];
	[saverNames addObjectsFromArray:[manager directoryContentsAtPath:localSaverDirectory]];
	
    // Get the previously stored defaults
	NSString *activationScriptPath = [defaults stringForKey:@"activationScriptPath"];
	NSString *deactivationScriptPath = [defaults stringForKey:@"deactivationScriptPath"];
	NSString *saverTitle = [defaults stringForKey:@"saverTitle"];
    NSNumber *aAsynch = (NSNumber *)[defaults objectForKey:@"actAsynch"];
    NSNumber *deaAsynch = (NSNumber *)[defaults objectForKey:@"deactAsynch"];
    NSNumber *sDesktop = (NSNumber *)[defaults objectForKey:@"showDesktop"];
	
    // Set the activation script textfield
	if (activationScriptPath)
	{
		[activationScriptLocation setStringValue:activationScriptPath];
	}
	
    // Set the deactivation script textfield
	if (deactivationScriptPath)
	{
		[deactivationScriptLocation setStringValue:deactivationScriptPath];
	}
    
    // Set the asynch checkbox
    if (aAsynch != nil)
    {
        [actAsynch setState:[aAsynch intValue]];
    }
    
    // Set the asynch checkbox
    if (deaAsynch != nil)
    {
        [deactAsynch setState:[deaAsynch intValue]];
    }
    
    if (sDesktop != nil)
    {
        [showDesktop setState:[sDesktop intValue]];
    }
	
    // Loop through each screen saver we found
	for (i = 0; i < [saverNames count]; i++)
	{
        // Get the name of the screen saver file
        NSString *saverItem = [saverNames objectAtIndex:i];
        
        // If it ends in .saver or .qtz and isn't ScriptSaver itself, add it to our list
		if (([[saverItem pathExtension] isEqualTo:@"saver"] && ![saverItem isEqualToString:@"ScriptSaver.saver"]) || [[saverItem pathExtension] isEqualTo:@"qtz"])
		{
			[saverList addItemWithTitle:[saverItem stringByDeletingPathExtension]];
		}
	}
	
    // Was a screen saver found in the defaults?
    if (saverTitle)
    {
        // Add the saver's extension back
        NSString *saverFileName = [saverTitle stringByAppendingPathExtension:@"saver"];
        NSString *qtzFileName = [saverTitle stringByAppendingPathExtension:@"qtz"];
        
        // Yes -- look for it first in the system directory
        if ([manager fileExistsAtPath:[systemSaverDirectory stringByAppendingPathComponent:saverFileName]] ||
            [manager fileExistsAtPath:[systemSaverDirectory stringByAppendingPathComponent:qtzFileName]])
        {
            // We found it!
            [saverList selectItemWithTitle:saverTitle];
        }
        // Not in the system directory, so look for it in the global directory
        else if ([manager fileExistsAtPath:[globalSaverDirectory stringByAppendingPathComponent:saverFileName]] ||
                 [manager fileExistsAtPath:[globalSaverDirectory stringByAppendingPathComponent:qtzFileName]])
        {
            // We found it!
            [saverList selectItemWithTitle:saverTitle];
        }
        // Not in the global directory, so look for it in the user directory
        else if ([manager fileExistsAtPath:[localSaverDirectory stringByAppendingPathComponent:saverFileName]] ||
                 [manager fileExistsAtPath:[localSaverDirectory stringByAppendingPathComponent:qtzFileName]])
        {
            // We found it!
            [saverList selectItemWithTitle:saverTitle];
        }
    }
}

- (IBAction)chooseActivationLocation:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	NSArray *theArray = [NSArray arrayWithObjects:@"scpt", @"applescript", nil];
    
    // Open a "choose file" picker for .scpt and .applescript files
	int result = [openPanel runModalForTypes:theArray];
    
    // Did the user chose a filename?
	if ((result == NSOKButton) && ([openPanel filenames] != nil))
	{
        // Yes, so populate the text field with it
		NSString *fileName = [[openPanel filenames] objectAtIndex:0];
		[activationScriptLocation setStringValue:fileName];
	}
}

- (IBAction)chooseDeactivationLocation:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	NSArray *theArray = [NSArray arrayWithObjects:@"scpt", @"applescript", nil];
    
    // Open a "choose file" picker for .scpt and .applescript files
	int result = [openPanel runModalForTypes:theArray];
    
    // Did the user chose a filename?
	if ((result == NSOKButton) && ([openPanel filenames] != nil))
	{
        // Yes, so populate the text field with it
		NSString *fileName = [[openPanel filenames] objectAtIndex:0];
		[deactivationScriptLocation setStringValue:fileName];
	}
}

- (IBAction)okAction:(id)sender
{
    // Why is this here?
	[[self window] makeFirstResponder:[self window]];
    
    // Save our preferences
    [defaults setObject:[activationScriptLocation stringValue] forKey:@"activationScriptPath"];
	[defaults setObject:[deactivationScriptLocation stringValue] forKey:@"deactivationScriptPath"];
	[defaults setObject:[saverList titleOfSelectedItem] forKey:@"saverTitle"];
    [defaults setObject:[NSNumber numberWithInt:[actAsynch state]] forKey:@"actAsynch"];
    [defaults setObject:[NSNumber numberWithInt:[deactAsynch state]] forKey:@"deactAsynch"];
    [defaults setObject:[NSNumber numberWithInt:[showDesktop state]] forKey:@"showDesktop"];
	[defaults synchronize];
    
    // Dismiss the configuration sheet
	[NSApp endSheet:[self window] returnCode:NSOKButton];
}

- (NSString *)activationScriptLocationString
{
    if ([defaults stringForKey:@"activationScriptPath"] == nil)
    {
        return [NSString stringWithString:@""];
    }
    return [NSString stringWithString:[defaults stringForKey:@"activationScriptPath"]];
}

- (NSString *)deactivationScriptLocationString
{
    if ([defaults stringForKey:@"deactivationScriptPath"] == nil)
    {
        return [NSString stringWithString:@""];
    }
	return [NSString stringWithString:[defaults stringForKey:@"deactivationScriptPath"]];
}

- (NSString *)saverLocation
{
    NSString *saverTitle = [defaults stringForKey:@"saverTitle"];
    
    // Get the screensaver directory paths
    NSFileManager *manager = [NSFileManager defaultManager];
	NSString *systemSaverDirectory = @"/System/Library/Screen Savers/";
    NSString *globalSaverDirectory = @"/Library/Screen Savers/";
	NSString *homeDir = NSHomeDirectory();
	NSString *localSaverDirectory = [homeDir stringByAppendingPathComponent:@"/Library/Screen Savers/"];
    
    // Was a screen saver found in the defaults?
    if (saverTitle)
    {
        // Add the saver's extension back
        NSString *saverFileName = [saverTitle stringByAppendingPathExtension:@"saver"];
        NSString *qtzFileName = [saverTitle stringByAppendingPathExtension:@"qtz"];
        
        // Yes -- look for it first in the system directory
        if ([manager fileExistsAtPath:[systemSaverDirectory stringByAppendingPathComponent:saverFileName]])
        {
            // We found it!
            return [systemSaverDirectory stringByAppendingPathComponent:saverFileName];
        }
        // Look for the .qtz file in that dir
        if ([manager fileExistsAtPath:[systemSaverDirectory stringByAppendingPathComponent:qtzFileName]])
        {
            // We found it!
            return [systemSaverDirectory stringByAppendingPathComponent:qtzFileName];
        }
        // Not in the system directory, so look for it in the global directory
        else if ([manager fileExistsAtPath:[globalSaverDirectory stringByAppendingPathComponent:saverFileName]])
        {
            // We found it!
            return [globalSaverDirectory stringByAppendingPathComponent:saverFileName];
        }
        // Look for the .qtz file in that dir
        else if ([manager fileExistsAtPath:[globalSaverDirectory stringByAppendingPathComponent:qtzFileName]])
        {
            // We found it!
            return [globalSaverDirectory stringByAppendingPathComponent:qtzFileName];
        }
        // Not in the global directory, so look for it in the user directory
        else if ([manager fileExistsAtPath:[localSaverDirectory stringByAppendingPathComponent:saverFileName]])
        {
            // We found it!
            return [localSaverDirectory stringByAppendingPathComponent:saverFileName];
        }
        // Look for the .qtz file in that dir
        else if ([manager fileExistsAtPath:[localSaverDirectory stringByAppendingPathComponent:qtzFileName]])
        {
            // We found it!
            return [localSaverDirectory stringByAppendingPathComponent:qtzFileName];
        }
    }
    
    return nil;
}

- (BOOL)activateAsynch
{
    NSNumber *checked = (NSNumber *)[defaults objectForKey:@"actAsynch"];
    
    if (checked == nil)
    {
        return YES;
    }
    
    return ([checked intValue] == NSOnState);
}

- (BOOL)deactivateAsynch
{
    NSNumber *checked = (NSNumber *)[defaults objectForKey:@"deactAsynch"];
    
    if (checked == nil)
    {
        return YES;
    }
    
    return ([checked intValue] == NSOnState);
}

- (BOOL)showDesktop
{
    NSNumber *checked = (NSNumber *)[defaults objectForKey:@"showDesktop"];
    
    if (checked == nil)
    {
        return YES;
    }
    
    return ([checked intValue] == NSOnState);
}

@end
