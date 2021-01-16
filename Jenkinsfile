pipeline {
    agent any
    environment { 
        registry = "${registry}" 
        registryCredential = "${registryCredential}"  
        //dockerImage = '' 
    }
    stages {
        stage('Cloning Git Repository branch prod') { 
            when {
                branch 'prod'
            }
            steps { 
                git branch: 'prod', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
            }
        }
        stage('Cloning Git Repository branch dev') { 
            when {
                branch 'dev'
            }
            steps { 
                git branch: 'dev', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
            }
        }
        stage('Cloning Git Repository branch master') { 
            when {
                branch 'master'
            }
            steps { 
                git branch: 'master', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
            }
        } 
        stage('Building image') { 
            steps { 
                script { 
                    app = docker.build(registry) 
                }
            } 
        }
        stage('Deploy image') {
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest") 
                    }
                } 
            }
        }
        stage('Remove Unused docker image') {
            steps{
                sh "docker image prune -a -f"
            }
        }
        stage('Delete Old Deployments') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh 'kubectl delete -f /var/lib/jenkins/workspace/news-demo-starter-files_prod/K8s/website-deployment.yaml' 
                }
            } 
        } 
        stage('Deploy to GKE') {
            steps{
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh 'kubectl apply -f /var/lib/jenkins/workspace/news-demo-starter-files_prod/K8s/' 
                }            
            }
        }
    }
    post {
        success {
            sh 'curl -s -X POST https://api.telegram.org/bot1464725701:AAEeIUxEZYGiTUXFXTNckm-DFnxdga9aXYw/sendMessage -d "chat_id=-320006499" -d text="news-demo-starter-files » prod : SUCCESS"'
        }
        unstable {
            sh 'curl -s -X POST https://api.telegram.org/bot1464725701:AAEeIUxEZYGiTUXFXTNckm-DFnxdga9aXYw/sendMessage -d "chat_id=-320006499" -d text="news-demo-starter-files » prod : UNSTABLE"'
        }
        failure {
            sh 'curl -s -X POST https://api.telegram.org/bot1464725701:AAEeIUxEZYGiTUXFXTNckm-DFnxdga9aXYw/sendMessage -d "chat_id=-320006499" -d text="news-demo-starter-files » prod : FAILED"'
        }
    }
}