This is our amazon linux ami build.
===================================

launch codepipeline cfn stack
-----------------------------


::

aws cloudformation validate-template \
--template-body file://cloudformation/pipeline.yaml

aws cloudformation create-stack \
--stack-name ucop-ami-builder-amazonlinux2 \
--template-body file://cloudformation/pipeline.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters \
 ParameterName=NotificationEmailAddress,ParameterValue="ait-dev@ucop.edu" \
 ParameterName=PackerProjectDir,ParameterValue=amazonlinux2_x86-64 \


aws cloudformation update-stack --stack-name ucop-ami-builder-amazonlinux2 --template-body file://cloudformation/pipeline.yaml --capabilities CAPABILITY_NAMED_IAM

aws cloudformation delete-stack --stack-name ucop-ami-builder-amazonlinux2
