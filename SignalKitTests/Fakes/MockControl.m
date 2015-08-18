//
//  MockControl.m
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MockControl.h"

@implementation MockControl

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    //
    // Thanks to ReactiveCocoa!
    // https://github.com/ReactiveCocoa/ReactiveCocoa
    //
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    [target performSelector:action withObject:nil];
    
    #pragma clang diagnostic pop
}

@end

@implementation MockButton

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    MockControl* control = [[MockControl alloc] init];
    
    [control sendAction:action to:target forEvent:event];
}

@end

@implementation MockDatePicker

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    MockControl* control = [[MockControl alloc] init];
    
    [control sendAction:action to:target forEvent:event];
}

@end

@implementation MockSegmentedControl

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    MockControl* control = [[MockControl alloc] init];
    
    [control sendAction:action to:target forEvent:event];
}

@end

@implementation MockSlider

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    MockControl* control = [[MockControl alloc] init];
    
    [control sendAction:action to:target forEvent:event];
}

@end

@implementation MockSwitch

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    MockControl* control = [[MockControl alloc] init];
    
    [control sendAction:action to:target forEvent:event];
}

@end

@implementation MockTextField

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    MockControl* control = [[MockControl alloc] init];
    
    [control sendAction:action to:target forEvent:event];
}

@end
