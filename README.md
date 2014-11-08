AQSInstagramActivity
====================

![](http://img.shields.io/cocoapods/v/AQSInstagramActivity.svg?style=flat) [![Build Status](https://travis-ci.org/AquaSupport/AQSInstagramActivity.svg)](https://travis-ci.org/AquaSupport/AQSInstagramActivity)

[iOS] UIActivity Class for Instagram

Usage
---

```objc
UIActivity *instaActivity = [[AQSInstagramActivity alloc] init];
NSArray *items = @[[UIImage imageNamed:@"someimage.png"]];

UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items withApplicationActivities:@[instaActivity]];

[self presentViewController:activityViewControoler animated:YES completion:NULL];
```

Installation
---

```
pod "AQSInstagramActivity"
```

Related Projects
---

- [AQSShareService](https://github.com/AquaSupport/AQSShareService) - UX-improved share feature in few line
