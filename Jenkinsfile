pipeline { 
    environment { 
        registry = "watri/website" 
        registryCredential = 'dockerhub' 
        dockerImage = '' 
    }
    agent none
    stages {
        stage('Cloning our Git') { 
            agent {
                label "docker_dev"
            }
            steps { 
                git branch: 'prod', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
            }
        } 
        stage('Building our image') {
            agent {
                label "docker_dev"
            } 
            steps { 
                script { 
                    dockerImage = docker.build registry + ":$BUILD_NUMBER" 
                }
            } 
        }
        stage('Deploy our image') {
            agent {
                label "docker_dev"
            } 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push() 
                    }
                } 
            }
        } 
        stage('Cleaning up') {
            agent {
                label "docker_dev"
            } 
            steps { 
                sh "docker rmi $registry:$BUILD_NUMBER" 
            }
        }
		stage('Run new container') {
            agent {
                label "docker_dev"
            } 
            steps { 
                script{
                     try {
                            sh "docker stop koala" 
				            sh "docker rm koala"  
                        } catch (e) {
                            echo: 'caugth error : $err'
                        }
                sh "docker container create --name koala -p 3000:3000 watri/website:$BUILD_NUMBER"
				sh "docker start koala"
				    }
                }				
            }
        stage('Deploy on Production?') {
            agent{
                label "docker_prd"
            }
            steps { 
                input 'Deploy on Production?'
                milestone (1)
                    script{
                        try {
                            sh "docker stop koala" 
				            sh "docker rm koala"  
                        } catch (e) {
                            echo: 'caugth error : $err'
                        }
                        sh "docker container create --name koala -p 3000:3000 watri/website:$BUILD_NUMBER"
                        sh "docker start koala"
                    }
               }
            }     
        }
    }