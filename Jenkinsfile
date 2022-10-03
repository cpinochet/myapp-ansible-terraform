// Define secret variables
// def SECRETKEY = 'secret'

pipeline{
  agent any
  /* environment {
        AWSCRIPKEY = 'QUtJQVRETFo0VE4yUUhPMzJSSFkK'
        AWSCRIPSEC = 'bitGZnU4TEQ2Yi82U0gxcVhNT09XclNNODNGNDh2QndiUVpvZ01MQgo='
    } */
  stages{
    /* stage('SCM Checkout'){
      steps{
        git 'https://github.com/cpinochet/myapp-ansible'
      }
    } */
    /* stage('printvar'){
      steps {
        wrap([$class: "MaskPasswordsBuildWrapper",
              varPasswordPairs: [[password: AWSCRIPKEY],
                                 [password: AWSCRIPSEC]]]) {
          echo "UserKey: ${AWSCRIPKEY}"
          echo "SecretKey: ${AWSCRIPSEC}"
        }
      }
    } */
    stage('Prework'){
      steps {
          sh '''
          echo -n "" > terra.log
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
        wrap([$class: "MaskPasswordsBuildWrapper",
              varPasswordPairs: [[password: AWSCRIPKEY],
                                 [password: AWSCRIPSEC]]]) {
          echo "UserKey: ${AWSCRIPKEY}"
          echo "SecretKey: ${AWSCRIPSEC}"
        }
          sh'''
          export AWS_ACCESS_KEY_ID=$(echo $AWSCRIPKEY | base64 -d)
          echo $AWS_ACCESS_KEY_ID
          export AWS_SECRET_ACCESS_KEY=$(echo $AWSCRIPSEC | base64 -d)
          echo $AWS_SECRET_ACCESS_KEY
          # terraform plan
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