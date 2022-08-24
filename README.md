# HopShop ios code test

HopShop is an app that helps shoppers to find the products they ar elooking for via visual search,

## Task

- Use GUEST api to get the token and store it locally
- Use LOCALIZATION endpoint to get the list of objects in the picture
- After image is localized the goal is to show a screen with uploaded image in it, with cropper set on the 1st object
- Show small, cropped images of localized objects
- User can adjust the cropper manually, or by tapping on small, cropped images
- Prepare to send the coordinates of cropper vertectes for next request

##

link to design: https://www.figma.com/file/hV6tL9Etz8eBiaWwcO30Ax/Untitled?node-id=1%3A2

## Endpoints

### Guest

POST: https://devapi.loupefy.com/auth/guest

response:
```json
{
    "data": {
        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiNjMwNWYzNTc1YzE5ODg4YjQyYzQwNGY5IiwiaWF0IjoxNjYxMzM0MzU5fQ.wfZUAqpPMhbuep_9ob50T1tKYRTLA96l2-Ix6g22RG4Q",
        "userid": "6305f3575c19888b42c404f9"
    },
    "msg": "Guest user successfully registered",
    "status": 200
}
```
use token in headers to have authenticated access to further endpoints

### Localization
POST: https://devapi.loupefy.com/localization

custom headers:

token: {tokne}
deviceid: test-device

body: 

form-data:

image: {file, imnage to be localized}

response:
```json
{
{
    "data": {
        "imageID": "1661334739-7dd7498f0df7433296c946f14a32de32",
        "objects": [
            {
                "category": "tops",
                "subCategory": "Dress",
                "vertices": {
                    "bottomLeft": {
                        "x": 0.014254812151193619,
                        "y": 0.990252673625946
                    },
                    "bottomRight": {
                        "x": 0.9903492331504822,
                        "y": 0.990252673625946
                    },
                    "topLeft": {
                        "x": 0.014254812151193619,
                        "y": 0.0
                    },
                    "topRight": {
                        "x": 0.9903492331504822,
                        "y": 0.0
                    }
                }
            }
        ]
    },
    "msg": "Success",
    "status": 200
}
}
```

objects is a list of objects containing an object called vertices, that should serve as a coordinates for the vertectes of the cropper
