pipeline {
    agent {
        docker {
            image 'moko1/build-project:latest'
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Clone project') {
            steps {
                git(url: 'https://github.com/Ullubiy/Boxfuse_pipeline.git', branch: 'main', poll: true, credentialsId: 'git')
            }
        }

        stage('Build war') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Make docker image') {
            steps {
                sh 'docker build -t boxfuse -f Dockerfile .'
                sh 'docker tag boxfuse:latest moko1/build-project:latest'
                withDockerRegistry([ credentialsId: "docker-hub-credentials", url: "" ]) {
                bat "docker push moko1/build-project:latest"
                }
            }
        }
    }

}
