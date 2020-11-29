pipeline { 
    environment { 
        registry = "watri/website" 
        registryCredential = 'dockerhub' 
        dockerImage = '' 
    }
    agent none
    stages {
        stage('Cloning Git Repository') { 
            agent {
                label "docker_dev"
            }
            steps { 
                git branch: 'prod', credentialsId: 'github_login', url: 'https://github.com/watri/news-demo-starter-files.git' 
            }
        } 
        stage('Building image') {
            agent {
                label "docker_dev"
            } 
            steps { 
                script { 
                    app = app = docker.build(registry) 
                    app.inside {
                        sh 'echo $(curl 54.179.131.146:3000)'
                    }
                }
            } 
        }
        stage('Deploy image') {
            agent {
                label "docker_dev"
            } 
            steps { 
                script { 
                    docker.withRegistry( 'https://registry.docker.com', registryCredential ) { 
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest") 
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
		stage('Run New Container') {
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
        stage('Deploy on Production') {
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
                        sh "docker container create --name koala -p 3000:3000 watri/website:latest"
                        sh "docker start koala"
                    }
               }
            }     
        }
    }