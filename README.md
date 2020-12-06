# Zeat - An easy way to eat
> Restaurant Table/Order management system for Dine-in/Online/Group ordering

This App is built for both Diners/Restaurant owners. The app allows user to search for restaurants nearby and allow them to order food online or choose the Dine-in option.

![](ZeatSearchAndDineIn.gif)

## Features

- [x] Diner Features
- [x] Location based Restaurant Search
- [x] View Restaurant Menu
- [x] Dine-in/Online Order
- [x] Join existing table (for Dine-in) to dine-in together
- [ ] Join existing order (for Online) to enable group ordering (Not yet implemented)
- [x] Approve dine-in request
- [ ] View server details for a personalized experience (Not yet implemented)
- [ ] Pay with multiple option (Split into X/Pay for what you ordered) (Not yet implemented)

## Requirements

- iOS 11.0+
- Swift 4.2

## Libraries Used
- Alamofire
  - Making rest API calls to Zeat services hosted on AWS
- NVActivityIndicatorView
  - Custom Activity indicator for a better experience
- AlamorfireImage
  - Image processing/services
- Eureka
  - Dynamic menu option display based on restaurant menu definition (JSON based)
- AWSCognitoIdentityProvider
  - User management
- AWSSNS
  - User validation
- GooglePlaces
  - Places search by City Name


```
github "kumaresansv/zeat-diner"
```
## Meta

Kumaresan – kumaresansv@gmail.com


[https://github.com/kumaresansv/zeat-diner/](https://github.com/kumaresansv/)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
