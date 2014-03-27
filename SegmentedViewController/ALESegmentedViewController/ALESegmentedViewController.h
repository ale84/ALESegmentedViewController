//  Created by Alessio on 11/03/14.
//  Copyright (c) 2014 Alessio. All rights reserved.

//  container view with a segmented control to switch between view controllers

#import <UIKit/UIKit.h>

@class ALESegmentedViewController;

@protocol ALESegmentedViewControllerDelegate <NSObject>
@optional
- (void)segmentedViewController:(ALESegmentedViewController *)segmentedController willShowViewController:(UIViewController *)viewController;
- (void)segmentedViewController:(ALESegmentedViewController *)segmentedController didShowViewController:(UIViewController *)viewController;
- (void)segmentedViewController:(ALESegmentedViewController *)segmentedController willHideViewController:(UIViewController *)viewController;
- (void)segmentedViewController:(ALESegmentedViewController *)segmentedController didHideViewController:(UIViewController *)viewController;
@end

@interface ALESegmentedViewController : UIViewController
@property (nonatomic, strong, readonly) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign, readonly) NSUInteger selectedViewControllerIndex;
@property (nonatomic, weak) id<ALESegmentedViewControllerDelegate>delegate;

- (void)setSegmentedTitle:(NSString *)title forViewControllerAtIndex:(NSUInteger)index;

@end
