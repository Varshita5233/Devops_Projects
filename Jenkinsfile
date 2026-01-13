pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages{
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from git'){
            steps{
                git branch: 'feature-yt-clone-app', url: 'https://github.com/Varshita5233/youtube-clone-app.git'
            }
        }
        stage('Sonarqube Analysis'){
            steps{
                withSonarQubeEnv('SonarQube-Server') {
                    sh """
                    ${SCANNER_HOME}/bin/sonar-scanner \
                    -Dsonar.projectKey=Youtube-CICD \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://65.2.31.45:9000 \
                    -Dsonar.login=sqp_903f016459e4c5464d4765892fa26c833f17d337
                    """
                }
            }
        }
        stage('Quality Gate'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonarQube-Token'
                }
            }
        }
        stage('Install Dependencies'){
            steps{
                sh 'npm install'
            }
        }
        stage('Trivy scan'){
            steps{
                sh '''
                trivy fs --severity HIGH,CRITICAL --exit-code 1 . | tee trivyfs.txt
                '''
            }
        }
        stage('Docker build & push'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh """
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t youtube-clone .
                    docker tag youtube-clone $DOCKER_USER/youtube-clone:latest 
                    docker push $DOCKER_USER/youtube-clone:latest
                    docker logout
                    """
                }
            }
        }
        stage('scan docker image using Trivy'){
            steps{
                sh "trivy image jyotsna2181/youtube-clone:latest > trivyimage.txt "
            }
        }
        stage('Deploy to EKS cluster'){
            steps{
                script{
                    dir('kubernetes'){
                        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kubernetes', namespace: '', restrictKubeConfigAccess: false, serverUrl: ''){
                            sh"""
                            kubectl delete --all pods
                            kubectl apply -f deployment.yaml
                            kubectl apply -f service.yaml
                            """
                        }
                    }
                }
            }
        }
    }
}