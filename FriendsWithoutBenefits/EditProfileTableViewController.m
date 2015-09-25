//
//  EditProfileTableViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/25/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "EditProfileTableViewController.h"

@interface EditProfileTableViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIAlertController *imageSelector;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImageButton;
@property (weak, nonatomic) IBOutlet UITextField *editFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editLastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editAgeTextField;
@property (weak, nonatomic) IBOutlet UITextField *editAboutTextView;
@property (strong, nonatomic) UIImage *chosenImage;

@end

@implementation EditProfileTableViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addImage:(id)sender {
  self.imageSelector.modalPresentationStyle = UIModalPresentationPageSheet;
  [self presentViewController:self.imageSelector animated:true completion:nil];
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

@end
