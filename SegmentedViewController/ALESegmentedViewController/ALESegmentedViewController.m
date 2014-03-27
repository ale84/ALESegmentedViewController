//  Created by Alessio on 11/03/14.
//  Copyright (c) 2014 Alessio. All rights reserved.

#import "ALESegmentedViewController.h"

@interface ALESegmentedViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign, readwrite) NSUInteger selectedViewControllerIndex;
@property (nonatomic, strong, readwrite) IBOutlet UISegmentedControl *segmentedControl;
- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl;
- (void)showViewControllerAtIndex:(NSUInteger)index;
- (void)buildSegmentedControl;
- (void)callDelegateForWillShowForViewController:(UIViewController *)viewController;
- (void)callDelegateForWillHideForViewController:(UIViewController *)viewController;
- (void)callDelegateForDidShowForViewController:(UIViewController *)viewController;
- (void)callDelegateForDidHideForViewController:(UIViewController *)viewController;
@end

@implementation ALESegmentedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [self.view addSubview:toolbar];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
    UIBarButtonItem *flexibleLeftSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleRightSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:@[flexibleLeftSpace, buttonItem, flexibleRightSpace]];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
 
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 416)];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_containerView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:toolbar
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:-20]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_containerView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_containerView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbar][_containerView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(toolbar,_containerView)]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(toolbar)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self buildSegmentedControl];
    [self showViewControllerAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action methods

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl
{
    [self showViewControllerAtIndex:segmentedControl.selectedSegmentIndex];
}

- (void)showViewControllerAtIndex:(NSUInteger)index
{
    
    UIViewController *previousViewController = self.viewControllers[self.selectedViewControllerIndex];
    UIViewController *nextViewController = self.viewControllers[index];
    
    if (previousViewController) {
        [self callDelegateForWillHideForViewController:previousViewController];
    }
    if (nextViewController) {
        [self callDelegateForWillShowForViewController:nextViewController];
    }
    
    if (previousViewController.parentViewController == self) {
        [previousViewController.view removeFromSuperview];
        [previousViewController removeFromParentViewController];
    }

    //add controller as a child before calling its view, otherwise viewDidLoad would be called before the parentViewController is set 
    [self addChildViewController:nextViewController];
    nextViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:nextViewController.view];

    
    NSDictionary *bindingsDictionary = @{@"subview": nextViewController.view};
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:bindingsDictionary]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:bindingsDictionary]];

    if (previousViewController) {
        [self callDelegateForDidHideForViewController:previousViewController];
    }
    if (nextViewController) {
        [self callDelegateForDidShowForViewController:nextViewController];
    }
    
    self.selectedViewControllerIndex = index;
    [self.segmentedControl setSelectedSegmentIndex:self.selectedViewControllerIndex];
    
}

- (void)buildSegmentedControl
{
    [self.segmentedControl removeAllSegments];
    
    for (int i = 0; i < [_viewControllers count]; i++) {
        UIViewController *viewController = self.viewControllers[i];
        [self.segmentedControl insertSegmentWithTitle:viewController.title atIndex:i animated:NO];
        [self.segmentedControl sizeToFit];
    }
}

#pragma mark - setters/getters

- (void)setViewControllers:(NSArray *)viewControllers
{
//    UIViewController *selectedViewController = self.viewControllers[self.selectedViewControllerIndex];
//    [selectedViewController removeFromParentViewController];
//    [selectedViewController.view removeFromSuperview];
    
    _viewControllers = viewControllers;
    
    if (self.isViewLoaded) {    //se la view non è ancora caricata, non deve aggiornare
        [self buildSegmentedControl];
        [self showViewControllerAtIndex:0];
    }

}

#pragma mark - public interface

- (void)setSegmentedTitle:(NSString *)title forViewControllerAtIndex:(NSUInteger)index
{
    [self.segmentedControl setTitle:title forSegmentAtIndex:index];
}

#pragma mark - utils

- (void)callDelegateForWillHideForViewController:(UIViewController *)viewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedViewController:willHideViewController:)]) {
        [self.delegate segmentedViewController:self willHideViewController:viewController];
    }
}

- (void)callDelegateForWillShowForViewController:(UIViewController *)viewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedViewController:willShowViewController:)]) {
        [self.delegate segmentedViewController:self willShowViewController:viewController];
    }
}

- (void)callDelegateForDidHideForViewController:(UIViewController *)viewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedViewController:didHideViewController:)]) {
        [self.delegate segmentedViewController:self didHideViewController:viewController];
    }
}

- (void)callDelegateForDidShowForViewController:(UIViewController *)viewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedViewController:didShowViewController:)]) {
        [self.delegate segmentedViewController:self didShowViewController:viewController];
    }
}

@end
