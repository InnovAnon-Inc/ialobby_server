# Use an official Python runtime as a base image
FROM python:3.8

# Set the working directory in the container
WORKDIR /src

# Copy the current directory contents into the container at /app
COPY . /src

# Install any needed packages specified in requirements.txt
#RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir .

WORKDIR /app
RUN rm -rf /src

# Make port 5000 available to the world outside this container
#EXPOSE 5000

# Define the command to run your application
ENTRYPOINT ["/usr/bin/env", "python", "-m", "ialobby"]
