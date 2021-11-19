ARG VERSION

# 基础镜像
FROM --platform=${TARGETPLATFORM} nnzbz/spring-boot-app

# 如果这里不重复定义参数，后面会取不到参数的值
ARG VERSION
ARG MAVEN_VERSION
ARG GIT_VERSION

ENV GIT_VERSION=${GIT_VERSION}

# 作者及邮箱
# 镜像的作者和邮箱
LABEL maintainer="nnzbz@163.com"
# 镜像的版本
LABEL version=${VERSION}
# 镜像的描述
LABEL description="Jenkins"

COPY ./run.sh /bin/
RUN chmod +x /bin/run.sh && /bin/run.sh

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://get.jenkins.io/war-stable/${VERSION}/jenkins.war
ARG MAVEN_ZIP_FILE_NAME=apache-maven-${MAVEN_VERSION}-bin.tar.gz
ARG MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_ZIP_FILE_NAME}

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/local/myservice/jenkins.war

RUN curl -fsSL ${MAVEN_URL} -o /tmp/${MAVEN_ZIP_FILE_NAME}

RUN tar zxvf /tmp/${MAVEN_ZIP_FILE_NAME} -C /usr/local && rm -f /tmp/${MAVEN_ZIP_FILE_NAME}

ENV PATH="/usr/local/apache-maven-${MAVEN_VERSION}/bin:${PATH}"

ENV MYSERVICE_FILE_NAME=jenkins.war





