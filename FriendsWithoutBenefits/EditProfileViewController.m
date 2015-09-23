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

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIAlertController *imageSelector;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImageButton;
@property (weak, nonatomic) IBOutlet UITextField *editFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editLastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editAgeTextField;
@property (weak, nonatomic) IBOutlet UITextField *editInterestsTextField;
@property (weak, nonatomic) IBOutlet UITextView *editAboutTextView;
@property (strong, nonatomic) UIImage *chosenImage;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.editFirstNameTextField.delegate = self;
  self.editLastNameTextField.delegate = self;
  self.editAgeTextField.delegate = self;
  self.editAboutTextView.delegate = self;
  [self setUpActionSheet];
  
  if (self.editUser) {
    [self setUpTextFields];
  }

    // Do any additional setup after loading the view.
}

-(void)setUpTextFields {
  //If your first name is not nil Display current first name
  if (self.editUser.firstName) {
    self.editFirstNameTextField.placeholder = self.editUser.firstName;
  }
  //If your last name is not nil Display its set name
  if (self.editUser.lastName) {
    self.editLastNameTextField.placeholder = self.editUser.lastName;
  }
  //If your age is not nil display its age
  if (self.editUser.age) {
    NSString *age = [NSString stringWithFormat:@"%@",self.editUser.age];
    self.editAgeTextField.placeholder = age;
  }else{
    self.editAgeTextField.placeholder = @"Please enter update your age";
  }
  //If your about me is not nil, display text
  if (self.editUser.aboutMe) {
    self.editAboutTextView.text = self.editUser.aboutMe;
  }else{
    self.editAboutTextView.text = @"Feel free to let the world know about you!";
  }
}

- (IBAction)editProfilePictureButtonPressed:(UIButton *)sender {
  self.imageSelector.modalPresentationStyle = UIModalPresentationPageSheet;
  [self presentViewController:self.imageSelector animated:true completion:nil];
}
- (IBAction)saveChangesButtonPressed:(UIButton *)sender {
  self.editUser.firstName = self.editFirstNameTextField.text;
  self.editUser.lastName = self.editLastNameTextField.text;
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  formatter.numberStyle = NSNumberFormatterDecimalStyle;
  NSNumber *age = [formatter numberFromString:self.editAgeTextField.text];
  self.editUser.age = age;
  self.editUser.aboutMe = self.editAboutTextView.text;
  self.editUser.profilePicture = self.chosenImage;
  
//  NSData *imageData = UIImagePNGRepresentation(self.chosenImage);
//  PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
//  
//  PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
//  userPhoto[@"imageName"] = @"My trip to Hawaii!";
//  userPhoto[@"imageFile"] = imageFile;
  
    //Figure out interests
  
  
  
  [self.editUser saveInBackground];
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

#pragma mark - UIImagePickerControllerDelegate and UINavigationControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

  UIImage *image = info[UIImagePickerControllerOriginalImage];
  self.chosenImage = [[UIImage alloc] init];
  self.chosenImage = image;
  [self.editProfileImageButton setImage:image forState:UIControlStateNormal];
  [self.picker dismissViewControllerAnimated:true completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self.picker dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.editAboutTextView endEditing:YES];
}

//- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text {
//  if ([text isEqualToString:@"\n"]) {
//    [self.editAboutTextView resignFirstResponder];
//    return NO;
//  }
//  return YES;
//}

@end
