# Secret Santa API

_WIP_

This should support secret santa once I implement everything.  
Python v3.8

## Documentation
API Docs can be found at [`documentation/`](documentation)

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

## TODO
- [x] Get Terraform deployment working
- [ ] Implement pairing algorithm with exclusions to prevent people from getting their SOs
- [ ] Add auth and tell Mitch how said auth works (probably just a bearer token but maybe I'm feeling fancy)
- [ ] Implement Notification - will likely use email, either sendgrid or AWS SES
- [ ] Profit