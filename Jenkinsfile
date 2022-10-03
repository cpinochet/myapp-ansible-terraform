// Define secret variables
// def SECRETKEY = 'secret'
def MY_AWS_SECRET_ACCESS_KEY = 'bitGZnU4TEQ2Yi82U0gxcVhNT09XclNNODNGNDh2QndiUVpvZ01MQgo='

pipeline{
  agent any
  stages{
    /* stage('SCM Checkout'){
      steps{
        git 'https://github.com/cpinochet/myapp-ansible'
      }
    } */
    stage('printvar'){
      steps {
        wrap([$class: "MaskPasswordsBuildWrapper",
              varPasswordPairs: [[password: AWS_SECRET_ACCESS_KEY]]]) {
          echo "Password: ${AWS_SECRET_ACCESS_KEY}"
        }
      }
    }
    stage('Prework'){
      steps {
          sh '''
          echo -n "" > terra.log
          export AWS_ACCESS_KEY_ID=$(echo $MY_AWS_ACCESS_KEY_ID | base64 -d)
          export AWS_SECRET_ACCESS_KEY=$(echo $MY_AWS_SECRET_ACCESS_KEY | base64 -d)
          '''
      }
    }
    stage('Terraform init'){
      steps{
          sh'''
          terraform init
          terraform fmt
          terraform validate
          '''
      }
    }
    stage('Terraform plan'){
      steps{
          sh'''
          terraform plan
          '''
      }
    }
    /* stage('Terraform deploy'){
      steps{
          sh'''
          terraform apply --auto-approve | tee terra.log
          '''
      }
    } */
    /* stage('post terra'){
      steps{
          sh'''
          echo "Updating ansible inventory file"
          EC2IP=$(cat terra.log | grep instance_public_ip | tail -n 1 | awk -F'"' '{print $2}')
          echo $EC2IP
          sed -i -e "s/EC2IP/${EC2IP}/g" dev.inv
          cat dev.inv
          '''
      }
    } */
    /* stage('Ansible Playbook'){
      steps{
          sh'''
          # cd /var/lib/jenkins/workspace/ansible/ansible_demo
          /usr/bin/ansible-playbook apache.yml -i dev.inv --private-key webserver_key.pem -u ec2-user
          '''
      }
    } */
  }
  post{
    always {
      echo 'Limpiando espacio de trabajo....'
      cleanWs()
    }
  }
}