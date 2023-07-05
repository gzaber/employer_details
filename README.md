<a href="https://github.com/gzaber/employer_details/actions"><img src="https://img.shields.io/github/actions/workflow/status/gzaber/employer_details/main.yaml" alt="build"></a>
<a href="https://codecov.io/gh/gzaber/employer_details"><img src="https://codecov.io/gh/gzaber/employer_details/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/gzaber/employer_details" alt="license MIT"></a>

# employer_details

A mobile application for storing frequently used data of the company where you work.  
You can store for example: invoice data, car data, phone numbers, addresses etc.

## Table of contents

- [Screenshots](#screenshots)
- [Features](#features)
- [Packages used](#packages-used)
- [Setup](#setup)
- [Test](#test)
- [Run](#run)

## Screenshots

[<img alt="details overview page" style="border: 1px solid grey" width="250px;"  src=".screenshots/details_overview.png" />](.screenshots/details_overview.png)
&nbsp;
[<img alt="edit mode" width="250px" style="border: .5px solid grey"  src=".screenshots/edit_mode.png" />](.screenshots/edit_mode.png)
&nbsp;
[<img alt="settings" width="250px" style="border: .5px solid grey"  src=".screenshots/settings.png" />](.screenshots/settings.png)
&nbsp;
[<img alt="create details" width="250px" style="border: .5px solid grey"  src=".screenshots/create_detail.png" />](.screenshots/create_detail.png)
&nbsp;
[<img alt="update detail" width="250px" style="border: .5px solid grey"  src=".screenshots/update_detail.png" />](.screenshots/update_detail.png)
&nbsp;
[<img alt="settings" width="250px" style="border: .5px solid grey"  src=".screenshots/vid_settings.gif" />](.screenshots/vid_settings.gif)
&nbsp;
[<img alt="edit mode 1" width="250px" style="border: .5px solid grey"  src=".screenshots/vid1_edit_mode.gif" />](.screenshots/vid1_edit_mode.gif)
&nbsp;
[<img alt="edit mode 1" width="250px" style="border: .5px solid grey"  src=".screenshots/vid2_edit_mode.gif" />](.screenshots/vid2_edit_mode.gif)
&nbsp;
[<img alt="edit mode 1" width="250px" style="border: .5px solid grey"  src=".screenshots/vid3_edit_mode.gif" />](.screenshots/vid3_edit_mode.gif)

## Features

- quick data preview
- data management
- reorder items
- import, export, share config
- share single item as text
- change theme / color scheme
- supported locales: en, pl

## Packages used

- cross_file
- file_picker
- flutter_bloc
- isar
- json_serializable
- share_plus
- shared_preferences

## Setup

Clone or download this repository.  
Use the following command to install all the dependencies:

```
$ flutter pub get
```

## Test

Run the tests using your IDE or using the following command:

```
$ flutter test --coverage
```

For local Flutter packages run the above command in the package root directory.  
For local Dart packages run the following commands in the package root directory:

```
$ dart pub global activate coverage
$ dart pub global run coverage:test_with_coverage
```

## Run

Run the application using your IDE or using the following command:

```
$ flutter run
```
