echo "wait for tekton-operator"
while [ $(kubectl get po -n tekton-operator | grep Running | wc -l) != 2 ]; do sleep 1; done

echo "wait for tekton-pipelines"
while [ $(kubectl get po -n tekton-pipelines | grep Running | wc -l) != 10 ]; do sleep 1; done

# TODO : change this when possible
echo "patch configuration"
kubectl patch tektonconfigs.operator.tekton.dev config --type merge --patch-file $(dirname $0)/patch-configuration.yaml
