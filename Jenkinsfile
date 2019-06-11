def CONTAINER_NAME="project-dockerizejenkinspipeline"
def CONTAINER_TAG="${env.BUILD_NUMBER}"
def DOCKER_HUB_USER="akrao"

node {
        stage('Initialize'){
                def dockerHome = tool 'myDocker'
                def mavenHome  = tool 'myMaven'
                env.PATH = "${dockerHome}/bin:${mavenHome}/bin:${env.PATH}"
        }
        stage('Checkout') {
                checkout scm
        }
        stage('Build') {
                sh 'mvn clean install'
        }
        stage('Test') {
                sh 'mvn test'
        }
        stage('Image Build'){
            try {
                    sh "docker image prune -f"
                    sh "docker stop $CONTAINER_NAME"
                } catch(error){}           
                sh "docker build -t $CONTAINER_NAME:$CONTAINER_TAG  -t $CONTAINER_NAME --pull --no-cache ."
                echo "Image build complete"
        }

        stage('Push to Docker Registry'){
                withCredentials([usernamePassword(credentialsId: 'dockerHubAccount', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "docker login -u $DOCKER_HUB_USER -p $PASSWORD"
                    sh "docker tag $CONTAINER_NAME:$CONTAINER_TAG $DOCKER_HUB_USER/$CONTAINER_NAME:$CONTAINER_TAG"
                    sh "docker push $DOCKER_HUB_USER/$CONTAINER_NAME:$CONTAINER_TAG"
                    echo "Image push complete"
                }
        }

        stage('Run App'){
                sh "docker pull $DOCKER_HUB_USER/$CONTAINER_NAME:$CONTAINER_TAG"
                sh "docker run $DOCKER_HUB_USER/$CONTAINER_NAME:$CONTAINER_TAG"            
        }
}
