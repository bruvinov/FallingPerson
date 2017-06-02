//
//  DraggableView.m
//  FallingPersons
//
//  Created by Boris Ruvinov on 3/30/16.
//  Copyright © 2016 Boris Ruvinov. All rights reserved.
//

#import "DraggableView.h"

@implementation DraggableView {
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
}


- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.superview];
    
    CGRect frame = self.frame;
    if (location.x > 50 && location.x + 50 < screenWidth) {
        frame.origin.x = location.x-50;
    }

    self.frame = frame;
    [_animator updateItemUsingCurrentState:self];
}


@end
