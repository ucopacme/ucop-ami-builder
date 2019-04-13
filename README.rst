aws cloudformation validate-template --template-body file://cloudformation/pipeline.yaml
aws cloudformation create-stack --stack-name ucop-ami-builder-amazonlinux2 --template-body file://pipeline.yaml --capabilities CAPABILITY_NAMED_IAM
