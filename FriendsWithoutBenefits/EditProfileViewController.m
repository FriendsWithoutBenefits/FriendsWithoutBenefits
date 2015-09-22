//
//  EditProfileViewController.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "EditProfileViewController.h"
#import "User.h"
#import <UIKit/UIKit.h>

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIAlertController *imageSelector;
@property (strong, nonatomic) UIImagePickerController *picker;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setUpActionSheet];

    // Do any additional setup after loading the view.
}
- (IBAction)editProfilePictureButtonPressed:(UIButton *)sender {
  self.imageSelector.modalPresentationStyle = UIModalPresentationPageSheet;
  [self presentViewController:self.imageSelector animated:true completion:nil];
}

- (void)setUpActionSheet {
  self.picker = [[UIImagePickerController alloc] init];
  self.picker.delegate = self;
  self.imageSelector = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Select image from: " preferredStyle:UIAlertControllerStyleActionSheet];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
  UIAlertAction *chooseImageFromPhotoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:true completion:nil];
  }];
  UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"Take a Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
      [self presentViewController:self.picker animated:true completion:nil];
    }
  }];
  
  [self.imageSelector addAction:chooseImageFromPhotoLibrary];
  [self.imageSelector addAction:takePicture];
  [self.imageSelector addAction:cancelAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIImagePickerControllerDelegate and UINavigationControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  UIImage *image = info[UIImagePickerControllerOriginalImage];
  //[self.editUser setProfilePicture:image];
  [self.editProfileImageButton setImage:image forState:UIControlStateNormal];
//  [self.editProfileImageButton setBackgroundImage:image forState:UIControlStateNormal];
  [self.picker dismissViewControllerAnimated:true completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self.picker dismissViewControllerAnimated:true completion:nil];
}

@end
