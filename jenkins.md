## Step 1 create a Jenkinsfile template
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

## Step 2: create a jenkins pipeline on the UI
   - New item
   - item type pipeline: java-todo-pipeline
   - configuration: 
      - pipeline: Pipeline from script from SCM
      - SCM: GIT
      - Repository URL: https://github.com/mishobo/java-todo
      - Branch Specifier: master
      - Apply & save
      - run build pipeline manually to test

## Step 3: Cloning stage syntax
```groovy
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
```

## Step 4: Building stage
```groovy
    stage('Build') {
        steps {
            sh './gradlew clean build -x test --no-daemon'
        }
    }
```

## Step 5: Run application's Tests stage
```groovy
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
```

## Step 6: Package application

```groovy
    stage('Package') {
        steps {
            sh './gradlew installDist -x test --no-daemon'
            archiveArtifacts artifacts: 'build/install/java-todo/**', fingerprint: true
        }
    }
```   

## Step 7: Containerizing the application
```groovy
    stage('Containerize') {
        steps {
            sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:build-${env.BUILD_NUMBER} ."
        }
    }
```        