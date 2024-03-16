# Use an official Node.js image as the base image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
#COPY package*.json ./

# Copy the rest of the client application files to the working directory
COPY . .

# Install dependencies
RUN npm install

RUN npm build

# Expose the port on which the application will run
EXPOSE 8080

# Define the command to start the application
ENTRYPOINT ["/usr/bin/env", "npm", "start"]

