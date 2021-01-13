pipeline {
    agent any
    environment {
   //     PROJECT_ID = 'watri-project'
   //     CLUSTER_NAME = 'watri-cluster'
   //     LOCATION = 'us-central1-c'
   //     CREDENTIALS_ID = 'Watri-Project' 
        registry = "watri/website" 
        registryCredential = 'docker_hub' 
        dockerImage = '' 
    }
    stages {
        stage('Cloning Git Repository') { 
            steps { 
                git branch: 'prod', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
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
        stage('DeployToProduction') {
            steps {
                input 'Deploy to Production?'
                 milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'nginx-deployment.yaml',
                    enableConfigSubstitution: true
                )
            }
        } 
       // stage('Deploy to GKE') {
       //     steps{
         //       step([
           //     $class: 'KubernetesEngineBuilder',
             //   projectId: env.PROJECT_ID,
              //  clusterName: env.CLUSTER_NAME,
             //   location: env.LOCATION,
             //   manifestPattern: 'K8s/',
             //   credentialsId: env.CREDENTIALS_ID,
             //   verifyDeployments: true])
           // }
       // }
     }
}