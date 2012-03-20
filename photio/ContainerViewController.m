//
//  ContainerViewController.m
//  photio
//
//  Created by Troy Stribling on 2/25/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ContainerViewController.h"
#import "ViewGeneral.h"

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    ViewGeneral* general = [ViewGeneral instance];
    [general createViews:self.view];
    [general cameraViewPosition:[ViewGeneral inWindow]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
