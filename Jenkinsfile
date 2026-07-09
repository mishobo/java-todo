    pipeline {
        agent any       
        stages {
            stage('Clone repository') {
                steps { 
                    echo "Cloning repository ..."
                }  
            }
            stage('Build') {
                steps { 
                    echo "Building application ..."
                }  
            }
            stage('Test') {
                steps {
                    echo "Testing application ..."
                }
            }
            stage('Package') {
                steps {
                    echo "Packaging application ..."
                }
            }
            stage('Containerize') {
                steps {
                    echo "Containerizing application ...."
                }
            }
            stage('Push to DockerHub') {
                steps {
                    echo "Pushing image to DockerHub ..."
                }
            }
            stage('Deploy') {
                steps {
                    echo "Deploying application ..."
                }
            }
        }
        post { 
            success {
                echo "Notify team pipeline was successful"
            }
            failure {
                echo "Notify team pipeline failed"
            }
            always {
                echo "Cleanup workspace"
            }
        }            
    }