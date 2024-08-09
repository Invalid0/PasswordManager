
# Mobile App Developer Assignment

## Project Overview

This project is a secure and user-friendly password manager application. The application is designed to help users store and manage their passwords securely and efficiently.

**Getting Started**: Includes installation steps.

## Installation

1. **Clone the Repository**

   Open a terminal and clone the repository to your local machine:

   ```bash
   git clone https://github.com/Invalid0/PasswordManager.git  ```
   
2. **Navigate to the Project Directory**
    - cd PasswordManager
    
3. **Open the Project**
    - Open the project in Xcode or your preferred ID (open PasswordManager.xcodeproj)


## Using the Application

### Add a New Password

1. **Launch the application.**
2. **Navigate to the "Add Password" screen.**
3. **Fill out the form with the following details:**
   - **Account Type:** Choose or enter the type of account (e.g., Gmail, Facebook).
   - **Username/Email:** Enter the username or email associated with the account.
   - **Password:** Enter the password for the account.
4. **Tap the "Save" button** to securely store the password.

### View or Edit Passwords

1. **On the home screen,** you will see a list of all saved passwords.
2. **Select an entry** to view its details.
3. **To edit, tap the list** and update the information as needed.
4. **After making changes, tap "Edit"** to update the entry.

### Delete a Password

1. **On the home screen,** locate the password entry you wish to delete.
2. **select list on the entry** and tap on the "Delete" button.
3. **Tap "Delete"** to remove the information from your list.

### Handle First-Time Access

- When first accessing the Details Screen, you might encounter an "Invalid Fetch" error if no data is available yet. This is expected behavior until you add and save some passwords.


**Technical Details**: Information about encryption, database usage, and UI design.
## Application Include Below Screen

1. **Add Password**
   - Users can securely add new passwords by providing details such as the account type (e.g., Gmail, Facebook, Instagram), username/email, and password.

2. **View/Edit Password**
   - Users should be able to view and edit existing passwords, including account details like username/email and password.

3. **Show List of Passwords on Home Screen**
   - The home screen of the application displays a list of all saved passwords, showing essential details for each entry.

4. **Delete Password**
   - Users should be able to delete passwords.

## FrameWorked Used

1. **Encryption**
   - CryptoKit, Security.

2. **Database**
   -  CoreData.

3. **User Interface**
   - Use proviede figma link to Design UI.

4. **Input Validation**
   - Implement validation to ensure that mandatory fields are not empty and data is properly formatted.

5. **Error Handling**
   - Properly handle errors and edge cases to ensure a smooth user experience.


## UI Design

- **Design Reference**
  -  Figma design [Figma link](https://www.figma.com/design/VYkl4ghM04eeaDcTpGo5hh/Password-Manager-App---Mobile-Team-Interview?node-id=0-1&t=qaEembaJuw1tn4EO-0).

