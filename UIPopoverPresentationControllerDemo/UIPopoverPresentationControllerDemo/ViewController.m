//
//  ViewController.m
//  UIPopoverPresentationControllerDemo
//
//  Created by bingoogol on 15/6/13.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import "ViewController.h"
#import "BGASecondViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self test];
}

- (void)test {
    BGASecondViewController *vc = [[BGASecondViewController alloc] init];
    
    vc.modalPresentationStyle = UIModalPresentationPopover;
    
//    vc.popoverPresentationController.sourceView = self.slider;
//    vc.popoverPresentationController.sourceRect = self.slider.bounds;
    
    vc.popoverPresentationController.sourceView = self.slider.superview;
    vc.popoverPresentationController.sourceRect = self.slider.frame;
    
    [self presentViewController:vc animated:YES completion:nil];
}


/**
 *  UIPopoverController只能运行在iPad上
 */
- (void)testUIPopoverController {
    BGASecondViewController *vc = [[BGASecondViewController alloc] init];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    [popover presentPopoverFromRect:self.slider.bounds inView:self.slider permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end