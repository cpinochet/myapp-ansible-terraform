pipeline{
  agent any
  environment {
        AWSCRIPKEY = 'QUtJQVk1UVNIU0JUNlJJN1UzT1QK'
        AWSCRIPSEC = 'Rll6ekx0dU1sNVc1RVRsRHZQemJnbmlHK2hCaUNEL21TVkZzR0NjUwo='
    }
  stages{
    stage('Prework'){
      steps {
          sh '''
          cp -f dev.inv-e dev.inv
          '''
      }
    }
    stage('Terraform init-plan'){
      steps{
          sh'''
          export AWS_ACCESS_KEY_ID=$(echo $AWSCRIPKEY | base64 -d)
          export AWS_SECRET_ACCESS_KEY=$(echo $AWSCRIPSEC | base64 -d)
          terraform init
          terraform fmt
          terraform validate
          terraform plan
          '''
      }
    }

    stage('Terraform deploy'){
      steps{
          sh'''
          export AWS_ACCESS_KEY_ID=$(echo $AWSCRIPKEY | base64 -d)
          export AWS_SECRET_ACCESS_KEY=$(echo $AWSCRIPSEC | base64 -d)
          terraform apply --auto-approve
          sleep 30
          '''
      }
    }
    stage('post terra'){
      steps{
          sh'''
          sleep 10
          echo "Updating ansible inventory file"
          EC2IP=$(terraform output instance_public_ip | awk -F'"' '{print $2}')
          echo $EC2IP
          sed -i -e "s/EC2IP/${EC2IP}/g" dev.inv
          cat dev.inv
          '''
      }
    }
    stage('Ansible Playbook'){
      steps{
          sh'''
          # cd /var/lib/jenkins/workspace/ansible/ansible_demo
          /usr/bin/ansible-playbook apache.yml -i dev.inv --private-key /tmp/webserver_key.pem -u ec2-user
          '''
      }
    }
  }
  post{
    always {
      echo 'Limpiando espacio de trabajo....'
      cleanWs()
    }
  }
}