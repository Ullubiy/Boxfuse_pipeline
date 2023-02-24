FROM ubuntu:18.04
RUN apt update
RUN apt install default-jdk -y
RUN apt install tomcat9 -y
RUN apt install maven -y
RUN apt install git -y
EXPOSE 8080
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /usr/src/boxfuse
RUN mvn -f /usr/src/boxfuse/pom.xml package
RUN cp /usr/src/boxfuse/target/hello-1.0.war /var/lib/tomcat9/webapps/