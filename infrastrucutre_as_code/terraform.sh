set -o allexport
source ../.env set


init() {
    echo "Initializing Terraform..."
    terraform init
    echo "Initialization completed."
}

validate() {
    echo "Validating Terraform configuration..."
    terraform validate
    echo "Validation completed."
}

plan() {
    echo "Creating Terraform execution plan..."
    terraform plan
    echo "Planning completed."
}

first_apply() {

    echo "Applying Terraform changes..."
    terraform apply
    echo "Application completed."

    sleep 30

    read -p "Please enter the shown master IP: " master_ip

    read -p "Please enter the absolute path to your kubectl config. (example: /home/user/.kube/config): " kube_path

    echo "Copying k3s.yaml from the master..."

    sudo scp -i ../k3s-cluster.pem ubuntu@"${master_ip}":/etc/rancher/k3s/k3s.yaml $kube_path # add correct path yourself

    echo "k3s.yaml copied successfully."

    echo "Updating kubeconfig file..."

    sudo sed -i "s/127.0.0.1/$master_ip/g" ~/.kube/config

    echo "kubeconfig file updated."

    echo "Applying manifests"

    kubectl apply --recursive -f ../manifests/

}

apply() {
    echo "Applying Terraform changes..."
    terraform apply
    echo "Application completed."
}

force_apply() {
    echo "Applying Terraform changes (auto-approve)..."
    terraform apply -auto-approve
    echo "Application completed."
}

destroy() {
    echo "Destroying Terraform resources..."
    terraform destroy
    echo "Destruction completed."
}

force_destroy() {
    echo "Destroying Terraform resources (auto-approve)..."
    terraform destroy -auto-approve
    echo "Destruction completed."
}

case "$1" in
    init)
        init
        ;;
    validate)
        validate
        ;;
    plan)
        plan
        ;;
    first_apply)
        first_apply
        ;;
    apply)
        apply
        ;;
    force_apply)
        force_apply
        ;;
    destroy)
        destroy
        ;;
    force_destroy)
        force_destroy
        ;;
    *)
        echo "Usage: $0 {init|validate|plan|first_apply|force_apply|destroy|force_destroy}"
        exit 1
        ;;
esac