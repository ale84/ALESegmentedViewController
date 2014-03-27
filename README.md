ALESegmentedViewController
==========================

A custom container view controller that allows to switch between childs using a SegmentedControl

Usage
==========================
Instantiate the view controller and pass it an array of viewcontrollers.
You can set a delegate to be notified when the currently selected view controller changes.
The title of the segmentedControl segments matches the value of the title property of the corresponding view controller.

	//...
    FirstViewController *first = [[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
    SecondViewController *second = [[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
    
    ALESegmentedViewController *segmentedViewController = [[ALESegmentedViewController alloc]init];
    segmentedViewController.viewControllers = @[first, second];
    //...
