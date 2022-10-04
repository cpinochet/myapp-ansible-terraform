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
          echo -n "" > terra.log
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

    stage("Stage with input") {
    steps {
      def userInput = false
        script {
            def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
            echo 'userInput: ' + userInput

            if(userInput == true) {
                // do action
            } else {
                // not do action
                echo "Action was aborted."
                sh 'exit 1'
            }
        }    
    }  
}

    stage('Terraform deploy'){
      steps{
          sh'''
          echo "Deployng..."
          export AWS_ACCESS_KEY_ID=$(echo $AWSCRIPKEY | base64 -d)
          export AWS_SECRET_ACCESS_KEY=$(echo $AWSCRIPSEC | base64 -d)
          terraform apply --auto-approve
          sleep 20
          terraform output > terra.log
          '''
      }
    }

    stage('post terra'){
      steps{
          sh'''
          sleep 15
          echo "Updating ansible inventory file"
          EC2IP=$(cat terra.log | grep instance_public_ip | tail -n 1 | awk -F'"' '{print $2}')
          echo $EC2IP
          sed -i -e "s/EC2IP/${EC2IP}/g" dev.inv
          cat dev.inv
          '''
      }
    }

    stage('Ansible Playbook'){
      steps{
          sh'''
          /usr/bin/ansible-playbook apache.yml -i dev.inv --private-key webserver_key.pem -u ec2-user
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