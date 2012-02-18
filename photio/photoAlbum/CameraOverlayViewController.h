#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@protocol CameraOverlayViewControllerDelegate;

@interface CameraOverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    id <CameraOverlayViewControllerDelegate> delegate;    
    UIImagePickerController* imagePickerController;    
@private
    UIBarButtonItem *takePictureButton;
}    

@property (nonatomic, assign) id <CameraOverlayViewControllerDelegate> overlay_delegate;
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
