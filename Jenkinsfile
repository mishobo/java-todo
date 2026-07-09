pipeline {
        agent any       
        stages {
            stage('Checkout') {
                steps {
                    checkout scm
                    script {
                        env.GIT_COMMIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                        def branch = (env.BRANCH_NAME ?: env.GIT_BRANCH ?: 'unknown').replaceFirst(/^origin\//, '')
                        env.GIT_BRANCH_NAME = branch
                        env.IS_RELEASE_BRANCH = (branch == 'main' || branch == 'master').toString()
                        env.IMAGE_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT_SHORT}"
                    }
                    echo "Building ${env.GIT_BRANCH_NAME} @ ${env.GIT_COMMIT_SHORT} as ${env.IMAGE_NAME}:${env.IMAGE_TAG} (release branch: ${env.IS_RELEASE_BRANCH})"
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