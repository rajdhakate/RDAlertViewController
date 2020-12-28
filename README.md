# RDAlertViewController
An example of how to create or implement a custom alert view controller. 

Provides completion handlers for easy control handling. Added presentation animation for better experience.
> There are no public customization options for now. Any UI change needed to be made to the internal files.

## Usage

1. Drag drop the RDAlertViewController inside your project
2. To present the alert view, 

```
        // Custom popup
        let customPopupVC = RDAlertViewController()
        let yesAction = RDAlertAction(title: "Yes") { (alert) in
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = RDAlertAction(title: "Cancel") { (alert) in
            alert.dismiss(animated: true, completion: nil)
        }
        customPopupVC.setWith(title: "Are you sure you want to leave the app ?", subtitle: nil, actions: [yesAction, cancelAction])
        
        customPopupVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customPopupVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customPopupVC, animated: true)
```

## Feel free to customize your own. Any recommendations are welcome.
