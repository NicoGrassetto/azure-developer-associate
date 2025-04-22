# Use the official Python 3.9 image as the base image
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file to the working directory
COPY requirements.txt .

# Install the Python dependencies listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy all files from the current directory to the working directory in the container
COPY . .

# Expose port 8000 to allow external access
EXPOSE 8000

# Define the command to run the application
CMD ["python", "app.py"]