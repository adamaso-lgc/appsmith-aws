# Variables
$clusterName = "ClusterName"
$oidcProviderURL = "oidcProviderURL"
$accountId = "accountId"
$roleName = "AmazonEKS_EBS_CSI_DriverRole"
$policyName = "KMS_Key_For_Encryption_On_EBS_Policy"
$kmsKeyArn = "kmsKeyArn"

# Update aws-ebs-csi-driver-trust-policy.json with actual values
$trustPolicyContent = Get-Content -Path .\aws-ebs-csi-driver-trust-policy.json -Raw
$trustPolicyContent = $trustPolicyContent -replace "ACCOUNT_ID_PLACEHOLDER", $accountId
$trustPolicyContent = $trustPolicyContent -replace "OIDC_PROVIDER_URL_PLACEHOLDER", $oidcProviderURL
$trustPolicyContent | Set-Content -Path .\aws-ebs-csi-driver-trust-policy-updated.json

# Create IAM Role
aws iam create-role --role-name $roleName --assume-role-policy-document file://aws-ebs-csi-driver-trust-policy-updated.json

# Attach AWS Managed Policy
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --role-name $roleName

# KMS Policy - Customize if necessary. The provided JSON file must be manually updated with your KMS Key ARN before running this script.
$kmsPolicyContent = Get-Content -Path .\kms-key-for-encryption-on-ebs.json -Raw
$kmsPolicyContent = $kmsPolicyContent -replace "CUSTOM_KEY_ARN_PLACEHOLDER", $kmsKeyArn
$kmsPolicyContent | Set-Content -Path .\kms-key-for-encryption-on-ebs-updated.json

# Create and attach the KMS policy
$kmsPolicy = aws iam create-policy --policy-name $policyName --policy-document file://kms-key-for-encryption-on-ebs-updated.json
$kmsPolicyArn = $kmsPolicy | ConvertFrom-Json | Select-Object -ExpandProperty Policy | Select-Object -ExpandProperty Arn
aws iam attach-role-policy --policy-arn $kmsPolicyArn --role-name $roleName

# Output
Write-Host "IAM role and policies setup complete."

# Installing the Amazon EBS CSI Driver
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update

helm upgrade --install aws-ebs-csi-driver --namespace kube-system aws-ebs-csi-driver/aws-ebs-csi-driver

# Verifying the installation
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver


