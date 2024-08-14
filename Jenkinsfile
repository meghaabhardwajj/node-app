pipeline {
    
      agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    } 
    
    stages{
        
        stage('Checkout'){
            steps{
                url: 'https://github.com/meghaabhardwajj/node-app.git', branch: 'dev' 
            }
        }
        
        stage('Build Image'){
            steps{
               script{
                    sh '''
                    echo 'Buid Docker Image' 
                    docker build -t meghaabhardwajj/argocd-nodeapp:${BUILD_NUMBER} .
                    '''
               }
            }
        }
        
        stage('Push Docker Image'){
            steps{
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'PASSWORD')]) {
        	     sh 'docker login -u meghaabhardwajj -p $PASSWORD'
                 sh 'docker push meghaabhardwajj/argocd-nodeapp:${BUILD_NUMBER}'
                }
            }
        }
        stage('Checkout K8S manifest SCM'){
            steps {
                git credentialsId: 'GITHUB_CICD_TOKEN', 
                url: 'https://github.com/meghaabhardwajj/cicd-demo-manifests.git',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo'){
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'GITHUB_CICD_TOKEN', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cat deploy.yaml
                        sed -i "s/v1/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
                        git config --global user.email "meghaabhardwajj@gmail.com"
                        git config --global user.name "Megha Bhardwaj"
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git push https://$GIT_USERNAME:$GIT_PASSWORD@github.com/meghaabhardwajj/cicd-demo-manifests.git HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
