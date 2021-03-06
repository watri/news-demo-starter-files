pipeline { 
    environment { 
        registry = "watri/website" 
        registryCredential = 'dockerhub' 
        dockerImage = '' 
    }
    agent {
        label 'docker_prd'
    }
    stages {
        stage('Cloning our Git') { 
            steps { 
                git branch: 'master', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
            }
        } 
        stage('Building our image') { 
            steps { 
                script { 
                    dockerImage = docker.build registry + ":$BUILD_NUMBER" 
                }
            } 
        }
        stage('Deploy our image') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push() 
                    }
                } 
            }
        } 
        stage('Cleaning up') { 
            steps { 
                sh "docker rmi $registry:$BUILD_NUMBER" 
            }
        }
		stage('Remove old container') { 
            steps { 
                sh "docker stop website2" 
				sh "docker rm website2"
				}
        }
		stage('Run new container') { 
            steps { 
                sh "docker container create --name website2 -p 3000:3000 watri/website:$BUILD_NUMBER"
				sh "docker start website2"
				}				
            }
        }
    }