//
//  ASControlNode+tvOS.m
//  Texture
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the /ASDK-Licenses directory of this source tree. An additional
//  grant of patent rights can be found in the PATENTS file in the same directory.
//
//  Modifications to this file made after 4/13/2017 are: Copyright (c) 2017-present,
//  Pinterest, Inc.  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//

#import <Foundation/Foundation.h>
#if TARGET_OS_TV
#import <AsyncDisplayKit/ASControlNode.h>
#import <AsyncDisplayKit/ASControlNode+Private.h>

@implementation ASControlNode (tvOS)

#pragma mark - tvOS
- (void)_pressDown
{
  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    [self setPressedState];
  } completion:^(BOOL finished) {
    if (finished) {
      [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFocusedState];
      } completion:nil];
    }
  }];
}

- (BOOL)canBecomeFocused
{
  return YES;
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context
{
  return YES;
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
  //FIXME: This is never valid inside an ASCellNode
  if (context.nextFocusedView && context.nextFocusedView == self.view) {
    //Focused
    [coordinator addCoordinatedAnimations:^{
      [self setFocusedState];
    } completion:nil];
  } else{
    //Not focused
    [coordinator addCoordinatedAnimations:^{
      [self setDefaultFocusAppearance];
    } completion:nil];
  }
}

- (void)setFocusedState
{
  CALayer *layer = self.layer;
  layer.shadowOffset = CGSizeMake(2, 10);
  [self applyDefaultShadowProperties: layer];
  self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
}

- (void)setPressedState
{
  CALayer *layer = self.layer;
  layer.shadowOffset = CGSizeMake(2, 2);
  [self applyDefaultShadowProperties: layer];
  self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
}

- (void)applyDefaultShadowProperties:(CALayer *)layer
{
  layer.shadowColor = [UIColor blackColor].CGColor;
  layer.shadowRadius = 12.0;
  layer.shadowOpacity = 0.45;
  CGPathRef shadowPath = CGPathCreateWithRect(self.layer.bounds, NULL);
  layer.shadowPath = shadowPath;
  CGPathRelease(shadowPath);
}

- (void)setDefaultFocusAppearance
{
  CALayer *layer = self.layer;
  layer.shadowOffset = CGSizeZero;
  layer.shadowColor = [UIColor blackColor].CGColor;
  layer.shadowRadius = 0;
  layer.shadowOpacity = 0;
  CGPathRef shadowPath = CGPathCreateWithRect(self.layer.bounds, NULL);
  layer.shadowPath = shadowPath;
  CGPathRelease(shadowPath);
  self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
}
@end
#endif
