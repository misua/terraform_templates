

//This code will first check if the Config Map my-config-map exists. If it does not exist, 
//1.) the terraform apply command will be run to create the Config Map. 
//2.) If the Config Map does exist, the terraform apply command will not be run.


//You can also use the if statement to execute different actions based on the contents of the Config Map.
//For example, the following Terraform code will create a Pod if the Config Map 
//my-config-map has a key called image and the value of the key is nginx:


provider "kubernetes" {
  host = "https://api.kubernetes.default.svc"
  client_certificate = file("./kubeconfig/ca.crt")
  client_key = file("./kubeconfig/client.key")
}

resource "kubernetes_config_map" "my_config_map" {
  name = "my-config-map"
  data = {
    image = "nginx"
  }
}

output "config_map_name" {
  value = kubernetes_config_map.my_config_map.name
}

resource "kubernetes_pod" "my_pod" {
  name = "my-pod"
  image = data.kubernetes_config_map.my_config_map.data.image
}

if !kubectl get configmap my-config-map >/dev/null 2>&1; then
  terraform apply
fi

if kubectl get configmap my-config-map -o jsonpath="{.data.image}" == "nginx"; then
  terraform apply
fi
