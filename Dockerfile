FROM tomcat:8.0
# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat
COPY /var/lib/jenkins/workspace/other_pipeline_test/target/java-webapp.war /usr/local/tomcat/webapps/
