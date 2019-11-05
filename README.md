# check-datastores-space
PS script to check free space on VMWare VCenter datastores. Script should run from vmware powercli. 
After successfull run, there will be a CSV file on the out. 
On script there are 3 statuses of datastores - OK, Warning and Critical. 
Warning - for all datastores where free space is less then 10% and for those datastores, where all of available space is less then provisioned space (this situation my accure if you are using dynamicly expending virtual hard drives). 
Critical - for all datastores where free space is less then 5%.

Visit my blog - https://www.mytechnote.ru/
