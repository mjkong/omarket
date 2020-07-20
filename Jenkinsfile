pipeline {
  agent none
  stages {
    stage('Select region stage') {
      steps {
        input(message: 'Select region', id: 'seledtedRegion')
      }
    }
    stage('Stage1') {
      steps {
        echo '"Stage 1"'
      }
    }
  }
}