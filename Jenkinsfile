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