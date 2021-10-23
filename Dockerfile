FROM tomcat:8.0
COPY /var/lib/jenkins/workspace/other_pipeline_test/App/target/java-webapp.war /usr/local/tomcat/webapps/
