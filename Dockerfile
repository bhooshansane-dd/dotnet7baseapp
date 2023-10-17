#build base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS sdk-image
#select working directory on docker
WORKDIR /MyWebApplication

#copy all content to working directory
COPY . ./

#restore all dependencies
RUN dotnet restore

#publish released app in 'out' folder
RUN dotnet publish -c Release -o out

#build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /MyWebApplication

# copy from 'sdk-image' to 'out' directory inside working directory i.e. /MyWebApplication
COPY --from=sdk-image /MyWebApplication/out .

#expose the port on which the application is running locally.
EXPOSE 5000
#expose this port to docker so that it can be mapped with other
EXPOSE 80
ENV ASPNETCORE_URLS=http://*:5000

#provide a command to run the application
CMD ["dotnet","MyWebApplication.dll"]