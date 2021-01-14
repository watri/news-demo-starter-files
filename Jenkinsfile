pipeline {
    agent any
    environment {
        PROJECT_ID = "${PROJECT_ID}"
        CLUSTER_NAME = "${CLUSTER_NAME}"
        LOCATION = "${LOCATION}"
        CREDENTIALS_ID = "${CREDENTIALS_ID}" 
        registry = "${registry}" 
        registryCredential = "${registryCredential}"  
        dockerImage = '' 
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
                    sh 'kubectl delete -f /var/lib/jenkins/workspace/news-demo-starter-files_prod/K8s/nginx-deployment.yaml' 
                }
            } 
        } 
        stage('Deploy to GKE') {
            steps{
               step([
                $class: 'KubernetesEngineBuilder',
                projectId: env.PROJECT_ID,
                clusterName: env.CLUSTER_NAME,
                location: env.LOCATION,
                manifestPattern: 'K8s/',
                credentialsId: env.CREDENTIALS_ID,
                verifyDeployments: true])
            }
        }
        // stage('Push Notification') {
        //     steps {
        //         script{
        //             withCredentials([string(credentialsId: 'telegramToken', variable: 'TOKEN'),
        //             string(credentialsId: 'telegramChatId', variable: 'CHAT_ID')]) {
        //             telegramSend(message:'${PROJECT_NAME}:${BUILD_STATUS}',chatId:${CHAT_ID})
        //             }
        //         }
        //     }
        // }
        // stage('Push Notification') {
        //     steps {
        //         script{
        //             withCredentials([string(credentialsId: 'telegramToken', variable: 'TOKEN'),
        //             string(credentialsId: 'telegramChatId', variable: 'CHAT_ID')]) {
        //             sh """
        //             curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode="HTML" -d text="<b>Project</b> : POC \
        //             <b>Branch</b>: prod \
        //             <b>Build </b> : OK \
        //             <b>Test suite</b> = Passed"
        //             """
        //             }
        //         }   
        //     }
        // }
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
    //  post{
    //     always{
    //         script{
    //                 withCredentials([string(credentialsId: 'telegramToken', variable: 'TOKEN'),
    //                 string(credentialsId: 'telegramChatId', variable: 'CHAT_ID')]) {
    //                 telegramSend(message:'${PROJECT_NAME}:${BUILD_STATUS}',chatId:${CHAT_ID})
    //                 }
    //        // telegramSend(message: "Hello World", chatId: -320006499)
    //        // sh 'curl -s -X POST https://api.telegram.org/bot1464725701:AAEeIUxEZYGiTUXFXTNckm-DFnxdga9aXYw/sendMessage -d "chat_id=-320006499" -d text="${PROJECT_NAME}:${BUILD_STATUS}"'
    //         //telegramSend(message:'${PROJECT_NAME}:${BUILD_STATUS}',chatId:-320006499)
    //         }
    //     }
    // }
}