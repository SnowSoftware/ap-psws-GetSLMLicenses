# ap-psws-GetSLMLicenses

## Description
Snow Automation Platform PowerShell WebService that retrieves licenses from Snow License Manager. Will return license(s) either by filter (See SLM API documentation for filter instructions) if supplied, or single license by Id if supplied, or else all licenses. 

## Object properties
Licenses returned will have the following properties:
  
* Id              
* ApplicationName 
* ManufacturerName
* Metric          
* AssignmentType  
* PurchaseDate    
* Quantity        
* IsIncomplete    
* UpdatedDate     
* UpdatedBy       

```json
['Id','ApplicationName','ManufacturerName','Metric','AssignmentType','PurchaseDate','Quantity','IsIncomplete','UpdatedDate','UpdatedBy']
```

## Repository
This script is maintained in the GitHub Repository found [here](https://github.com/SnowSoftware/ap-psws-GetSLMLicenses).  
Please use GitHub issue tracker if you have any issues with the module. 