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
    stage('Push Docker image to Dockerhub') {
      steps{
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh 'sudo docker push ccza/capstone:latest'
      }
    }
  }
}
