# Secret Santa API

_WIP_

This should support secret santa once I implement everything.  
Python v3.8

## Deploy
Make sure Python dependencies are up-to-date in `src/package`:  
In your virtualenv
```shell
pip freeze > requirements.txt
pip install -r requirements.txt --target ./src/package
```

Then terraform
```shell
cd terraform
terraform init
terraform apply
```