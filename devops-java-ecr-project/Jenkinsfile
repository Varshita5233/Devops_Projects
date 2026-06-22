pipeline{
    agent any
    environment{
        AWS_REGION='ap-south-2'
        IMAGE_TAG='latest'


    }
    stages{
        stage('Checkout'){
            steps{
                checkout scm
            }
        }
        stage('Build Java JAR with maven'){
            steps{
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build docker Image'){
            steps{
                sh 'docker build -t ${ECR_REPO_NAME}:${IMAGE_TAG} .'
            }
        }
        stage('Push to ECR'){
            steps{
                sh '''
                aws ecr get-login password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                docker tag $ECR_REPO_NAME:$IMAGE_TAG $FULL_IMAGE_NAME
                docker push $FULL_IMAGE_NAME
                '''
            }
        }
        stage('Deploy to ECS Fargate'){
            steps{
                sh '''
                aws ecs update-service \ 
                    --cluster ${CLUSTER_NAME} \
                    --service ${SERVICE_NAME} \
                    --force-new-deployment \
                    --region ${AWS_REGION}


                '''
            }
        }
    }
    post{
        success{
            script{
                sh '''
                echo "Deployment successful"
                '''
            }
        }
        failure{
            echo "piepline failed."
        }
    }
}