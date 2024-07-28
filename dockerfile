#using the latest NGINX image from the Docker Hub
FROM nginx:latest
#entrypoint to the appropriate NGINX executable and
#making sure the NGINX server is running in the foreground
ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;"]
#edit the default index.html file to display a the needed message
RUN echo "yo this is nginx" > /usr/share/nginx/html/index.html
#expose the port 80
EXPOSE 80