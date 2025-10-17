# Tiny Python + Flask container
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Default port (mapped by ECS/ALB target group)
ENV PORT=80
EXPOSE 80

# Alarm match string for demo; override via task env if needed
ENV ALARM_MATCH_STRING=ALERT_TRIGGER

CMD ["python", "app.py"]
