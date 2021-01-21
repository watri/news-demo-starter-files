pipeline {
    agent { 
        kubernetes{
            label 'jenkins-slave'
        }
        
    }
    environment{
        DOCKER_USERNAME = credentials('DOCKER_USERNAME')
        DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
    }
    stages {
        stage('docker login') {
            steps{
                sh(script: """
                    docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                """, returnStdout: true) 
            }
        }

        stage('git clone') {
            steps{
                sh(script: """
                    git clone https://github.com/watri/news-demo-starter-files.git
                """, returnStdout: true) 
            }
        }

        stage('docker build') {
            steps{
                sh script: '''
                #!/bin/bash
                cd $WORKSPACE/
                docker build . -t watri/website:${BUILD_NUMBER}
                '''
            }
        }

        stage('docker push') {
            steps{
                sh(script: """
                    docker push watri/website:${BUILD_NUMBER}
                """)
            }
        }

        stage('deploy') {
            steps{
                sh script: '''
                #!/bin/bash
                cd $WORKSPACE/
                #get kubectl
                curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
                chmod +x ./kubectl
                ./kubectl apply -f /K8s/website-namespace.yaml -n watri
                ./kubectl apply -f /K8s/website-deployment.yaml -n watri
                cat /K8s/website-deployment.yaml | sed s/1.0.0/${BUILD_NUMBER}/g | ./kubectl apply -n watri -f -
                ./kubectl apply -f /K8s/website-service.yaml -n watri
                '''
        }
    }
}
}
// pipeline {
//     agent any
//     environment { 
//         registry = "${registry}" 
//         registryCredential = "${registryCredential}"  
//         //dockerImage = '' 
//     }
//     stages {
//         stage('Cloning Git Repository branch prod') { 
//             when {
//                 branch 'prod'
//             }
//             steps { 
//                 git branch: 'prod', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
//             }
//         } 
//         stage('Building image') { 
//             steps { 
//                 script { 
//                     app = docker.build(registry) 
//                 }
//             } 
//         }
//         stage('Deploy image') {
//             steps { 
//                 script { 
//                     docker.withRegistry( '', registryCredential ) { 
//                         app.push("${env.BUILD_NUMBER}")
//                         app.push("latest") 
//                     }
//                 } 
//             }
//         }
//         // stage('Remove Unused docker image') {
//         //     steps{
//         //         sh "docker image prune -a -f"
//         //     }
//         // }
//         stage('Delete Old Deployments') {
//             steps {
//                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
//                     sh 'kubectl delete -f /var/lib/jenkins/workspace/news-demo-starter-files_prod/K8s/website-deployment.yaml -n prod' 
//                 }
//             } 
//         } 
//         stage('Deploy to GKE') {
//             steps{
//                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
//                     sh 'kubectl apply -f /var/lib/jenkins/workspace/news-demo-starter-files_prod/K8s/ -n prod' 
//                 }            
//             }
//         }
//         // stage('Deploy to GKE using Helm') {
//         //     steps{
//         //         catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
//         //             sh 'helm upgrade website-0-1610798990 /var/lib/jenkins/workspace/news-demo-starter-files_prod/helm/website' 
//         //         }            
//         //     }
//         // }
//     }
//     // post {
//     //     success {
//     //         sh 'curl -s -X POST https://api.telegram.org/bot1464725701:AAEeIUxEZYGiTUXFXTNckm-DFnxdga9aXYw/sendMessage -d "chat_id=-320006499" -d text="news-demo-starter-files » prod : SUCCESS"'
//     //     }
//     //     unstable {
//     //         sh 'curl -s -X POST https://api.telegram.org/bot1464725701:AAEeIUxEZYGiTUXFXTNckm-DFnxdga9aXYw/sendMessage -d "chat_id=-320006499" -d text="news-demo-starter-files » prod : UNSTABLE"'
//     //     }
//     //     failure {
//     //         sh 'curl -s -X POST https://api.telegram.org/bot1464725701:AAEeIUxEZYGiTUXFXTNckm-DFnxdga9aXYw/sendMessage -d "chat_id=-320006499" -d text="news-demo-starter-files » prod : FAILED"'
//     //     }
//     // }
// }