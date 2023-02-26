pipeline {
  agent {

    docker {
      image 'moko1/build_image:8000'
    }

  }

  stages {

    stage('Copy source with configs') {
      steps {
        git(url: 'https://github.com/Ullubiy/boxfuse.git', branch: 'master', poll: true, credentialsId: 'git')
        sh 'ssh-keyscan -H moko1/build_image >> ~/.ssh/known_hosts'
        sh 'scp moko1/build_image:/home/jenkins/build/configs/staging/gateway-api/application-business-config-defaults.yml gateway-api/src/main/resources/application-business-config-defaults.yml'
      }
    }

    stage('Build jar') {
      steps {
        sh 'gradle bootRepackage'
      }
    }

    stage('Make docker image') {
      steps {
        sh 'cp -R gateway-api/build/libs/* docker-setup/shop/gateway-api && cd docker-setup/shop/gateway-api && docker build --tag=gateway-api .'
        sh '''docker tag gateway-api devcvs-srv01:5000/shop2-backend/gateway-api:2-staging && docker push devcvs-srv01:5000/shop2-backend/gateway-api:2-staging'''

      }
    }

    stage('Run docker on devbe-srv01') {
      steps {
        sh 'ssh-keyscan -H moko1/build_image >> ~/.ssh/known_hosts'
        sh '''ssh moko1/build_image << EOF
	sudo docker pull moko1/build_image:8000/shop2-backend/gateway-api:2-staging
	cd /etc/shop/docker
	sudo docker-compose up -d
EOF'''
      }
    }
  }
  triggers {
    pollSCM('*/1 H * * *')
  }
}