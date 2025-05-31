pipeline {
    // 파이프라인을 어떤 노드에서 실행할지 결정
    agent any
    
    tools {
        jdk "amazon-corretor-jdk17"
    }
    
    // 환경 변수
    environment {
        PROFILE = "${PROFILE}" // 프로파일(prod, stg)
        AWS_REGION = "ap-northeast-2" // AWS Region 정보
        AWS_ACCOUNT_ID = "842675972665" // AWS Acocunt 정보
        AWS_ECR_REPOSITORY = "search-jenkins-pipeline-${PROFILE}" // AWS ECR Repository 정보
        AWS_ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_ECR_REPOSITORY}" // AWS ECR URL
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}" // Docker Image Tag
        DOCKER_IMAGE = "${AWS_ECR_URL}:${DOCKER_IMAGE_TAG}" // Docker Image
    }

    // 파이프라인의 단계
    stages {
        // 디버깅
        stage("Debug") {
            steps {
                echo "================================================"
                echo "> Check Environment Variables"
                echo "AWS_REGION: ${AWS_REGION}"
                echo "AWS_ACCOUNT_ID: ${AWS_ACCOUNT_ID}"
                echo "AWS_ECR_REPOSITORY: ${AWS_ECR_REPOSITORY}"
                echo "AWS_ECR_URL: ${AWS_ECR_URL}"
                echo "DOCKER_IMAGE_TAG: ${DOCKER_IMAGE_TAG}"
                echo "DOCKER_IMAGE: ${DOCKER_IMAGE}"
                echo "PROFILE: ${PROFILE}"
                echo "================================================"
                echo "> Check Java Version"
                sh "java --version"
                echo "================================================"
                echo "> Check Docker Version"
                sh "docker --version"
                echo "================================================"
            }
        }
        
        // Git Clone 수행
        stage("Git Clone") {
            steps { 
                echo "================================================"
                echo "> Git Clone 수행"
                git credentialsId: "github-credentials-id", 
                branch: "master",
                url: "https://github.com/ym1085/springboot-jenkins-pipeline"
                echo "================================================"
            }
        }

        // Gradle Build 수행
        stage("Gradle Build") {
            steps {
                echo "================================================"
                echo "> Gradle 빌드 수행"
                sh "chmod +x ./gradlew"
                sh "./gradlew clean build -x test"
                echo "================================================"
            }
        }

        // Docker build 수행
        stage("Docker build") {
            steps {
                echo "================================================"
                echo "> Docker 빌드 수행"
                sh "docker build -t ${DOCKER_IMAGE} ."
                echo "================================================"
            }
        }

        // ECR Login
        stage("ECR Login") {
            steps { 
                echo "================================================"
                echo "> ECR Login"
                sh """
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${AWS_ECR_URL}
                """
                echo "================================================"
            }
        }

        // ECR Push
        stage("ECR Push") {
            steps {
                echo "================================================"
                echo "> ECR Push"
                sh "docker push ${DOCKER_IMAGE}"
                echo "================================================"
            }
        }
    }

    post {
        success {
            echo "================================================"
            echo "✅ Success Build"
            echo "================================================"
        }
        failure {
            echo "================================================"
            echo "❌ Fail Build"
            echo "================================================"
        }
    }
}