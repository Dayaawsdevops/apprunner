# Use official Python base image
FROM python:3.10-slim

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .

RUN pip install -r requirements.txt

# Copy the app
COPY app.py .

# Expose the port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]

