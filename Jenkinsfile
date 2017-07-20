node {
    // Clean workspace before doing anything
    deleteDir()

    try {
        stage ('Prepare:Environment') {
          checkout scm
        }
        stage ('Download execution packages') {
          sh 'mkdir -p ~/archives'
          sh 'wget https://volafile.org/get/axdRE-f9kAHz/sample-1.1-SNAPSHOT.tar.gz'
          sh 'wget https://volafile.org/get/axdhNzdbq4A4/vagrant.tar.gz'
          sh 'cp *.tar.gz ~/archives/'
        }
        stage ('Execute scripts') {
          // sh 'ansible-galaxy -r jenkins-test-requirements.yml -p roles/ install'
          sh './master-installer.sh -a sample-1.1-SNAPSHOT -t w1h1'
        }
    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
    }
}
