###############################################
# Remove an AMI and it's associated snapshots #
###############################################

# Set vars for your environment
export AWS_PROFILE="packer-build"
export AWS_REGION="us-east-1"
export AMI_NAME="my-test-image"

# get AMI_ID by substituting the ImageName you used, or check the console
AMI_ID=$(aws ec2 describe-images --filters Name=name,Values=$AMI_NAME | jq -j '. | .Images[0].ImageId')
if [ -n "${AMI_ID}" ] && [ "${AMI_ID}" != "null" ]; then
  echo "de-register AMI: $AMI_ID";
  # deregister the image
  aws ec2 deregister-image --image-id $AMI_ID;
  sleep 2
fi

# get the snapshots created (this assumes the name is unique)
SNAPS=(`aws ec2 describe-snapshots --filters Name=tag:Name,Values=$AMI_NAME | jq -r '.Snapshots | .[].SnapshotId'`)
# remove snapshots
for snap in "${SNAPS[@]}";
do
  echo "delete snapshot: $snap";
  aws ec2 delete-snapshot --snapshot-id $snap;
done
