# Use a slim official Python base image
FROM public.ecr.aws/docker/library/python:3.7-slim


# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    gcc \
    libssl-dev \
    libffi-dev \
    curl \
    vim \
    netcat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv (optional) or upgrade pip
RUN pip install --upgrade pip

# Copy project files
COPY . /app/

# Install dependencies
RUN pip install -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Run DB migrations (you can also do this in ECS entrypoint or init container)
RUN python manage.py makemigrations && python manage.py migrate
RUN python manage.py rebuild_index

# Expose port
EXPOSE 8001

# Start the server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8001"]
