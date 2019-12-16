FROM mcr.microsoft.com/dotnet/framework/runtime

LABEL maintainer="cremator"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN $j = Invoke-RestMethod -Uri "https://api.github.com/repos/Radarr/Radarr/releases"; \
	$jr = Invoke-RestMethod -Uri ('https://api.github.com/repos/Radarr/Radarr/releases/tags/'+$j.tag_name[0]); \
	foreach ($t in $jr.assets) {if ($t.name -like '*windows.zip') {$jd = $t.browser_download_url}}; \
    Invoke-WebRequest $jd -OutFile c:\radarr.zip ; \
    Expand-Archive c:\radarr.zip -DestinationPath C:\ ; \
    Remove-Item -Path c:\radarr.zip -Force; \
	Start-Process "C:\Radarr\ServiceInstall.exe" -Wait; \	
	Start-Sleep -s 10; \
	Stop-Service -name "Radarr" -Force -ErrorAction SilentlyContinue; \
	Start-Sleep -s 10; \
	Remove-Item "C:/ProgramData/Radarr" -Force -Recurse

EXPOSE 7878

VOLUME [ "C:/ProgramData/Radarr", "C:/movies" ]

CMD "Get-Content C:\ProgramData\Radarr\logs\radarr.txt -Wait"
