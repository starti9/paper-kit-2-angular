# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:18 as ui-build

# Set the working directory
WORKDIR /usr/local/app

# Add the source code to app
COPY ./ /usr/local/app/

# Install npm dependencies
RUN npm install -g npm@9.5.0

# Install all the dependencies
RUN npm install --legacy-peer-deps

# Generate the build of the application
RUN npm run build

# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:latest as server-build

# Copy the build output to replace the default nginx contents.
COPY --from=ui-build /usr/local/app/dist/ /usr/share/nginx/html

# Copy the default nginx.conf provided by tiangolo/node-frontend
COPY /nginx.conf  /etc/nginx/conf.d/default.conf


# Expose port 80
EXPOSE 80