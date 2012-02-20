#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@protocol CameraOverlayViewControllerDelegate;

@interface CameraOverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    __weak id <CameraOverlayViewControllerDelegate> overlayDelegate;    
    UIImagePickerController* imagePickerController;    
@private
    UIBarButtonItem *takePictureButton;
}    

@property (nonatomic, weak) id <CameraOverlayViewControllerDelegate> overlayDelegate;
@property (nonatomic, retain) UIImagePickerController* imagePickerController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* takePictureButton;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@protocol CameraOverlayViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
@end
