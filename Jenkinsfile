pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  }
  stages {
    stage('Clean workspace') {
      steps {
        cleanWs deleteDirs: true
      }
    }
    stage('Build WAR') {
      steps {
        sh 'mkdir -p App'
        dir("App") {
          git url: 'https://github.com/ipcrm/java_webapp_war.git'
          sh 'mvn --quiet clean package'
        }
      }
    }
    stage('Fetch infrastructure code') {
      steps {
        sh 'mkdir -p Infra'
        dir("Infra") {
          git branch: 'main', url: 'https://github.com/coolingcza/capstone.git'
        }
      }
    }
    stage('Create image build directory') {
      steps {
        sh 'mkdir -p Build'
        sh 'cp App/target/java-webapp.war Build'
        sh 'cp Infra/Dockerfile Build'
      }
    }
    stage('Build Docker image') {
      steps {
        dir("Build") {
          sh 'sudo docker build -t ccza/capstone:latest .'
        }
      }
    }
    //stage('Test application in docker image') {
    //  steps {
    //    //sh 'sudo docker run -d -p 42006:8081 ccza/capstone'
    //    //sh 'curl http://localhost:42006'
    //    script {
    //      final String url = "http://localhost:42006"
    //      final String response = sh(script: "curl -s $url", returnStdout: true).trim()
    //      echo response
    //    }
    //  }
    //}
    stage('Push Docker image to Dockerhub') {
      steps{
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh 'sudo docker push ccza/capstone:latest'
      }
    }
    stage('Deploy Docker image') {
      steps{
        dir("Infra") {
          sh 'ansible-playbook deploy.yaml -i hosts'
        }
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
