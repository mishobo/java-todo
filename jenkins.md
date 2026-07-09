### Jenkinsfile template

```groovy
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
            stage('Deploy') {
                steps {
                    echo "Deploy deploying application ..."
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
```