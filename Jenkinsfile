node {
    // Clean workspace before doing anything
    deleteDir()

    try {
        stage ('Prepare:Environment') {
          checkout scm
        }
        stage ('Download execution packages') {
          sh 'mkdir -p ~/archives'
          //sh 'wget https://volafile.org/get/axdRE-f9kAHz/sample-1.1-SNAPSHOT.tar.gz'
          //sh 'wget https://volafile.org/get/axdhNzdbq4A4/vagrant.tar.gz'
          //sh 'cp *.tar.gz ~/archives/'
        }
        stage ('Execute scripts') {
          sh 'chmod +x master-installer.sh'
          sh 'sudo apt-get install ansible -y'
            sh 'sudo apt-get install vagrant -y'
          // sh 'ansible-galaxy -r jenkins-test-requirements.yml -p roles/ install'
          sh 'ansible-playbook -i env-local vagrant-deploy.yml --extra-vars "TOPOLOGY=w1h1 APPLICATION_PACKAGE_NAME=sample-1.1-SNAPSHOT"'
          //sh './master-installer.sh -a sample-1.1-SNAPSHOT -t w1h1'
        }
    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
    }
}
