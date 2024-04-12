# flutter_kneron_fr

Kneron FR module monitor program

## Description

- basic screen created
- basic APIs are implemented including enroll
- Working normally
- DB export feature implemented
  - Read user id via "Verify" command
  - Input user id field and request "DB Exp" (Database export)
  - Check its DB size from response
  - Input offset and data size at input field (0 for offset and size which should less than total DB size)
  - Request "Upload Data"
  - Console will show what you sent and got
  - DB data save to filesystem
    - c:\2024-04-12_17-16.bin

## TODO

- DB import feature
- Delete user
- IR image upload from module and pop up image
- OTA feature

## History

- customized button, checkbox added
