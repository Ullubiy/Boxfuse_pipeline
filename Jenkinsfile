pipeline {
  agent {

    docker {
      image 'moko1/build_image2:5000'
    }

  }

  stages {

    stage('Copy source with configs') {
      steps {
        git(url: 'https://github.com/Ullubiy/boxfuse.git', branch: 'master', poll: true, credentialsId: 'git')
        
              }
    }

    stage('Build war') {
      steps {
        sh 'mvn package'
      }
    }

    stage('Make docker image') {
      steps {
        sh 'cp -R gateway-api/build/libs/* docker-setup/gateway-api && cd docker-setup/gateway-api && docker build --tag=gateway-api .'
        sh '''docker tag gateway-api moko1/build_image2:5000/gateway-api:2-staging && docker push moko1/build_image2:5000/gateway-api:2-staging'''

      }
    }

    stage('Run docker on build server') {
      steps {
        sh 'ssh-keyscan -H moko1/build_image2 >> ~/.ssh/known_hosts'
        sh '''ssh moko1/build_image2 << EOF
	sudo docker pull moko1/build_image2:5000/shop2-backend/gateway-api:2-staging
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