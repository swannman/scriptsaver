//
//  ScriptSaverView.m
//  ScriptSaver
//
//  Created by Matthew Swann on Mon Sep 30 2002.
//  Copyright (c) 2002, Matthew M. Swann. All rights reserved.
//

#import "ScriptSaverView.h"

@implementation ScriptSaverView

+ (BOOL)performGammaFade
{
	return NO;
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{	
    // Typical...
    self = [super initWithFrame:frame isPreview:isPreview];
    
    // Initialize variables
    saverInstance = nil;
    hasExecuted = NO;
    taskFinished = NO;
    
    // Initialize the controller
    controller = [[ConfigureWindowController alloc] init];
    
    // Get the screensaver class we're going to run
    NSString *saverLocation = [controller saverLocation];
    
    if (saverLocation != nil)
    {
        isQtzSaver = [[saverLocation pathExtension] isEqualToString:@"qtz"];
        
        // Create an appropriate frame for the screensaver
        NSRect saverFrame = [self frame];
        
        if (isPreview)
        {
            // Handle preview frame correctly
            saverFrame.origin = NSZeroPoint;
        }
        
        if (isQtzSaver)
        {             
            qtzView = [[QCView alloc] initWithFrame:saverFrame];
            [qtzView setAutostartsRendering:YES];
            [qtzView loadCompositionFromFile:saverLocation];
            [qtzView setFrame:saverFrame];
        }
        else
        {
            NSBundle *saverBundle = [NSBundle bundleWithPath:saverLocation];
            
            if (saverBundle != nil)
            {
                id saverClass = [saverBundle principalClass];
                
                if (saverClass != nil)
                {
                    // Instantiate the saver
                    saverInstance = [[saverClass alloc] init];
                    
                    // Initialize the screensaver instance
                    [saverInstance initWithFrame:saverFrame isPreview:isPreview];
                    [saverInstance setFrame:saverFrame];
                }
                else
                {
                    NSLog(@"Couldn't get principal class");
                }
            }
            else
            {
                NSLog(@"Couldn't load bundle at %@", saverLocation);
            }
        }
    }
    
	return self;
}

- (BOOL)isOpaque
{
    return FALSE;
}

- (void)startAnimation
{
    [super startAnimation];
    
    if (![self isPreview])
    {
        if (([controller showDesktop] && ![controller activateAsynch])
            || ((saverInstance == nil) && !isQtzSaver))
        {
            [[self window] setAlphaValue:0.0];
        }
        
        NSString *scriptLocation = [NSString stringWithString:[controller activationScriptLocationString]];
        
        if (![scriptLocation isEqualToString:@""])
        {
            if ([controller activateAsynch])
            {
                taskFinished = YES;
                [NSTask launchedTaskWithLaunchPath:[NSString stringWithString:@"/usr/bin/osascript"] 
                                         arguments:[NSArray arrayWithObject:scriptLocation]];
            }
            else
            {              
                NSDictionary *errDict;
                NSURL *actLocation = [NSURL fileURLWithPath:scriptLocation];
                NSAppleScript *scriptTask = [[NSAppleScript alloc] initWithContentsOfURL:actLocation error:&errDict];
                
                [scriptTask executeAndReturnError:&errDict];
                taskFinished = YES;
                
                if ((saverInstance != nil) && (!isQtzSaver))
                {
                    [[self window] setAlphaValue:1.0];
                }
            }
        }
        else
        {
            taskFinished = YES;
        }
    }
    else
    {
        taskFinished = YES;
    }
}

- (void)animateOneFrame
{
    if (!hasExecuted && ([self isPreview] || taskFinished))
    {
        hasExecuted = YES;

        if (isQtzSaver)
        {
            [self addSubview:qtzView];
        }
        else
        {
            [self addSubview:saverInstance];
            [saverInstance startAnimation];
        }
    }
}

- (void)stopAnimation
{  
    [super stopAnimation];
    [saverInstance removeFromSuperviewWithoutNeedingDisplay];
    
    if (![self isPreview] && [controller showDesktop] && ![controller deactivateAsynch])
    {
        [[self window] setAlphaValue:0.0];
    }
    
    if (![self isPreview])
    {
        NSString *scriptLocation = [NSString stringWithString:[controller deactivationScriptLocationString]];
        
        if ([controller deactivateAsynch])
        {
            [NSTask launchedTaskWithLaunchPath:[NSString stringWithString:@"/usr/bin/osascript"] 
                                     arguments:[NSArray arrayWithObject:scriptLocation]];
        }
        else
        {
            NSDictionary *errDict;
            NSURL *deactLocation = [NSURL fileURLWithPath:scriptLocation];
            NSAppleScript *scriptTask = [[NSAppleScript alloc] initWithContentsOfURL:deactLocation error:&errDict];
            
            [scriptTask executeAndReturnError:&errDict];
        }
    }
}

- (BOOL)hasConfigureSheet
{
	return YES;
}

- (NSWindow*)configureSheet
{
	return [controller window];
}


@end
