FROM microsoft/windowsservercore

SHELL ["powershell"]

# Install Open JDK
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.151-1/java-1.8.0-openjdk-1.8.0.151-1.b12.ojdkbuild.windows.x86_64.zip -OutFile openjdk.zip; \
    Expand-Archive openjdk.zip -DestinationPath $Env:ProgramFiles\Java; \
    Get-ChildItem -Path $Env:ProgramFiles\Java -Filter "java-*-openjdk*" | ForEach-Object {$_ | Rename-Item -NewName "OpenJDK" }; \
    Remove-Item -Force $Env:ProgramFiles\Java\OpenJDK\src.zip; \
    Remove-Item -Force openjdk.zip

# Install other things you need
# RUN ...

# Jenkins home
ENV JENKINS_HOME c:\\jenkins
RUN mkdir $env:JENKINS_HOME
WORKDIR $JENKINS_HOME

# PATH
RUN $path = $env:path + ';c:\Program Files\Java\OpenJDK\bin\'; Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $path
LABEL \
    com.trilogy.company="YOUR COMPANY NAME" \
    com.trilogy.maintainer.email="YOUR EMAIL" \
    com.trilogy.maintainer.skype="YOUR SKYPE"

# ENTRYPOINT while ($true) { Start-Sleep -Seconds 10 }