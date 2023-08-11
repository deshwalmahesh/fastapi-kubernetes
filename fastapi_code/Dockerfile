# Use the official Python image from Hub
FROM python:3.10

RUN mkdir /code

WORKDIR /code

# Copy the requirements only first as it is mostly supposed to change 
COPY requirements.txt .

# Without Caching
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the remaining Code
COPY . .

# This command runs your application, comment out this line to compile only
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
