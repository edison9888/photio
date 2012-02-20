#import "CameraOverlayViewController.h"

@implementation CameraOverlayViewController

@synthesize overlayDelegate, takePictureButton, imagePickerController;


#pragma mark -
#pragma mark CameraOverlayViewController

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType {
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.imagePickerController.showsCameraControls = NO;        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0) {
            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
            CGRect newFrame = CGRectMake(0.0,
                                         CGRectGetHeight(overlayViewFrame) -
                                         self.view.frame.size.height - 10.0,
                                         CGRectGetWidth(overlayViewFrame),
                                         self.view.frame.size.height + 10.0);
            self.view.frame = newFrame;
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
    }
}

- (IBAction)takePhoto:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)done:(id)sender {
    [self.overlayDelegate didFinishWithCamera];
    self.takePictureButton.enabled = YES;
}

#pragma mark -
#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (self.overlayDelegate)
        [self.overlayDelegate didTakePicture:image];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { 
    [self.overlayDelegate didFinishWithCamera];
}

@end

