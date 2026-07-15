    pipeline {
        agent {
            dockerContainer {
                image 'gradle:8.8-jdk17'
            }
        }
        environment {
            IMAGE_NAME             = 'mishobo/todo-list-app'
            CONTAINER_NAME         = 'todo-app'
            APP_PORT               = '4567'
            DOCKERHUB_CREDENTIALS  = 'dockerhub-credentials'  // Jenkins Credentials ID: Docker Hub username/password (or access token)
            DEPLOY_SSH_CREDENTIALS = 'vm-deploy-ssh-key'      // Jenkins Credentials ID: SSH private key
            DEPLOY_USER            = 'deploy'
            NOTIFY_EMAIL           = 'team@example.com'       // TODO: replace with your real notification list
        }     

        options {
            timeout(time: 15, unit: 'MINUTES')
            buildDiscarder(logRotator(numToKeepStr: '10'))
            disableConcurrentBuilds()
        }
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
                    sh './gradlew clean build -x test --no-daemon'
                }
            }
            stage('Test') {
                steps {
                    sh './gradlew test --no-daemon'
                }
                post {
                    always {
                        junit testResults: 'build/test-results/test/*.xml', allowEmptyResults: true
                    }
                }
            }
            stage('Package') {
                steps {
                    sh './gradlew installDist -x test --no-daemon'
                    archiveArtifacts artifacts: 'build/install/java-todo/**', fingerprint: true
                }
            }
            stage('Credential Test') {
                steps {
                    withCredentials([usernamePassword(
                        credentialsId: 'nexus-credentials',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS'
                    )]) {
                    sh 'echo "User: ${NEXUS_USER} Pass: ${NEXUS_PASS}"'
                }
            }
}
            stage('Containerize') {
                steps {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:build-${env.BUILD_NUMBER} ."
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