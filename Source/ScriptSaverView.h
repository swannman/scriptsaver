//
//  ScriptSaverView.h
//  ScriptSaver
//
//  Created by Matthew Swann on Mon Sep 30 2002.
//  Copyright (c) 2002, Matthew M. Swann. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "ConfigureWindowController.h"
#import <QTKit/QTKit.h>
#import <Quartz/Quartz.h>

@interface ScriptSaverView : ScreenSaverView 
{
    ConfigureWindowController *controller;
    id saverInstance;
    BOOL hasExecuted;
    BOOL taskFinished;
    BOOL isQtzSaver;
    QCView *qtzView;
}

+ (BOOL)performGammaFade;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview;

- (BOOL)isOpaque;

- (void)startAnimation;
- (void)animateOneFrame;
- (void)stopAnimation;

- (BOOL)hasConfigureSheet;
- (NSWindow*)configureSheet;

- (void)dealloc;

@end
