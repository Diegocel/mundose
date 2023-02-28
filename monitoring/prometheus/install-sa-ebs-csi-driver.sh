# Definimos el nombre de la policy creado
export EBS_CSI_POLICY_NAME="Amazon_EBS_CSI_Driver"
mkdir ${HOME}/environment/ebs_statefulset
cd ${HOME}/environment/ebs_statefulset
# Descargamos el archivo de IAM policy siguiente
curl -sSL -o ebs-csi-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json
# Creamos la policy de IAM
aws iam create-policy \
  --region ${AWS_REGION} \
  --policy-name ${EBS_CSI_POLICY_NAME} \
  --policy-document file://${HOME}/environment/ebs_statefulset/ebs-csi-policy.json

#Exportamos la policy con el ARN como variable
export EBS_CSI_POLICY_ARN=$(aws --region ${AWS_REGION} iam list-policies --query 'Policies[?PolicyName==`'$EBS_CSI_POLICY_NAME'`].Arn' --output text)

#Creamos el service-account
eksctl create iamserviceaccount \
  --cluster eks-mundos-e \
  --name ebs-csi-controller-irsa \
  --namespace kube-system \
  --attach-policy-arn $EBS_CSI_POLICY_ARN \
  --override-existing-serviceaccounts \
  --approve
  
# helm upgrade --install aws-ebs-csi-driver \
  --version=1.2.4 \
  --namespace kube-system \
  --set serviceAccount.controller.create=false \
  --set serviceAccount.snapshot.create=false \
  --set enableVolumeScheduling=true \
  --set enableVolumeResizing=true \
  --set enableVolumeSnapshot=true \
  --set serviceAccount.snapshot.name=ebs-csi-controller-irsa \
  --set serviceAccount.controller.name=ebs-csi-controller-irsa \
  aws-ebs-csi-driver/aws-ebs-csi-driver
  
# kubectl get pod -n kube-system -l “app.kubernetes.io/name=aws-ebs-csi-driver,app.kubernetes.io/intance=aws-ebs-csi-driver”